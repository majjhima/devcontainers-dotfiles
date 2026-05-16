#!/usr/bin/env -S npx tsx
/**
 * update-agent-zero-models.ts
 *
 * Opencode tool that fetches current text models from the Venice API
 * and updates the `provider.agent-zero.models` block in the global
 * opencode config (`~/.config/opencode/opencode.json`).
 *
 * Usage:
 *   npx tsx .opencode/tools/update-agent-zero-models.ts [--dry-run] [--config <path>]
 */

import { readFile, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { resolve } from "node:path";

const VENICE_API_URL = "https://api.venice.ai/api/v1/models";
const DEFAULT_CONFIG_PATH = resolve(homedir(), ".config/opencode/opencode.json");

interface VeniceModelSpec {
  availableContextTokens?: number;
  maxCompletionTokens?: number;
  name?: string;
}

interface VeniceModel {
  id: string;
  type: string;
  model_spec?: VeniceModelSpec;
}

interface ModelEntry {
  name: string;
  limit: {
    context: number;
    output: number;
  };
}

interface AgentZeroProvider {
  npm?: string;
  name?: string;
  options?: Record<string, unknown>;
  models?: Record<string, ModelEntry>;
}

interface OpenCodeConfig {
  $schema?: string;
  provider?: Record<string, AgentZeroProvider>;
  model?: string;
  small_model?: string;
  [key: string]: unknown;
}

function sentenceCase(str: string): string {
  return str.replace(/\w\S*/g, (txt) =>
    txt.charAt(0).toUpperCase() + txt.substring(1).toLowerCase()
  );
}

function stripProviderPrefix(name: string): string {
  return name.replace(/^[^/]+\//, "");
}

async function fetchVeniceModels(): Promise<VeniceModel[]> {
  const response = await fetch(VENICE_API_URL);
  if (!response.ok) {
    throw new Error(
      `Failed to fetch models: ${response.status} ${response.statusText}`
    );
  }

  const data = (await response.json()) as
    | VeniceModel[]
    | { data?: VeniceModel[] };

  const models = Array.isArray(data) ? data : data.data || [];
  return models.filter((m) => m.type === "text");
}

async function readConfig(configPath: string): Promise<OpenCodeConfig> {
  const content = await readFile(configPath, "utf8");
  return JSON.parse(content) as OpenCodeConfig;
}

async function writeConfig(
  configPath: string,
  config: OpenCodeConfig
): Promise<void> {
  await writeFile(configPath, JSON.stringify(config, null, 2) + "\n");
}

function buildModelsMap(
  apiModels: VeniceModel[],
  existingModels: Record<string, ModelEntry> = {}
): Record<string, ModelEntry> {
  const models: Record<string, ModelEntry> = {};

  for (const m of apiModels) {
    const spec = m.model_spec || {};
    const ctx = spec.availableContextTokens;
    const out = spec.maxCompletionTokens;

    if (ctx === undefined || out === undefined) {
      console.warn(`Skipping model ${m.id}: missing token limits`);
      continue;
    }

    const displayName = spec.name || m.id;
    const cleanedName = sentenceCase(stripProviderPrefix(displayName));

    models[m.id] = {
      name: existingModels[m.id]?.name || cleanedName,
      limit: {
        context: ctx,
        output: out,
      },
    };
  }

  return models;
}

function sortModelsByKey(
  models: Record<string, ModelEntry>
): Record<string, ModelEntry> {
  const sorted: Record<string, ModelEntry> = {};
  for (const key of Object.keys(models).sort()) {
    sorted[key] = models[key];
  }
  return sorted;
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const dryRun = args.includes("--dry-run");
  const configFlag = args.find((_, i) => args[i - 1] === "--config");
  const configPath = configFlag ? resolve(configFlag) : DEFAULT_CONFIG_PATH;

  console.log(`Fetching models from ${VENICE_API_URL}...`);
  const apiModels = await fetchVeniceModels();
  console.log(`Fetched ${apiModels.length} text models.`);

  console.log(`Reading config from ${configPath}...`);
  const config = await readConfig(configPath);

  if (!config.provider) {
    config.provider = {};
  }
  if (!config.provider["agent-zero"]) {
    config.provider["agent-zero"] = { models: {} };
  }

  const existing = config.provider["agent-zero"].models || {};
  const models = sortModelsByKey(buildModelsMap(apiModels, existing));

  const newCount = Object.keys(models).length;
  const existingCount = Object.keys(existing).length;
  console.log(
    `Found ${newCount} models from API (existing config had ${existingCount}).`
  );

  config.provider["agent-zero"].models = models;

  if (dryRun) {
    console.log("\n--- DRY RUN ---");
    console.log(JSON.stringify(models, null, 2));
    console.log("---------------\n");
    console.log("Config NOT written (dry-run mode).");
    return;
  }

  await writeConfig(configPath, config);
  console.log(`Updated ${newCount} models in ${configPath}`);

  // Verify
  const verify = await readConfig(configPath);
  const verifyModels = verify.provider?.["agent-zero"]?.models;
  if (!verifyModels) {
    throw new Error("Verification failed: models block missing after write.");
  }
  console.log("Config verified successfully.");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
