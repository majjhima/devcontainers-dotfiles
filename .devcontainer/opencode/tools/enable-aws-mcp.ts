#!/usr/bin/env -S npx tsx
/**
 * enable-aws-mcp.ts
 *
 * Opencode tool that enables the AWS MCP server in the global
 * opencode config (`~/.config/opencode/opencode.json`).
 *
 * Usage:
 *   npx tsx .opencode/tools/enable-aws-mcp.ts [--dry-run] [--config <path>]
 *
 * Environment variables:
 *   AWS_REGION   — defaults to "us-east-1"
 *   AWS_PROFILE  — defaults to "default"
 */

import { readFile, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { resolve } from "node:path";

const DEFAULT_CONFIG_PATH = resolve(homedir(), ".config/opencode/opencode.json");
const DEFAULT_REGION = "us-east-1";
const DEFAULT_PROFILE = "default";

interface MCPConfig {
  type: string;
  enabled: boolean;
  command: string[];
  environment: Record<string, string>;
}

interface OpenCodeConfig {
  $schema?: string;
  provider?: Record<string, unknown>;
  model?: string;
  small_model?: string;
  mcp?: Record<string, MCPConfig>;
  [key: string]: unknown;
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

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const dryRun = args.includes("--dry-run");
  const configFlag = args.find((_, i) => args[i - 1] === "--config");
  const configPath = configFlag ? resolve(configFlag) : DEFAULT_CONFIG_PATH;

  const region = process.env.AWS_REGION || DEFAULT_REGION;
  const profile = process.env.AWS_PROFILE || DEFAULT_PROFILE;

  console.log(`Reading config from ${configPath}...`);
  const config = await readConfig(configPath);

  if (!config.mcp) {
    config.mcp = {};
  }

  const awsMcp: MCPConfig = {
    type: "local",
    enabled: true,
    command: [
      "uvx",
      "mcp-proxy-for-aws@latest",
      `https://aws-mcp.us-east-1.api.aws/mcp`,
      "--metadata",
      `AWS_REGION=${region}`,
    ],
    environment: {
      AWS_PROFILE: profile,
    },
  };

  config.mcp.aws = awsMcp;

  if (dryRun) {
    console.log("\n--- DRY RUN ---");
    console.log(JSON.stringify({ mcp: { aws: awsMcp } }, null, 2));
    console.log("---------------\n");
    console.log("Config NOT written (dry-run mode).");
    return;
  }

  await writeConfig(configPath, config);
  console.log(`Enabled AWS MCP server in ${configPath}`);
  console.log(`  Region:  ${region}`);
  console.log(`  Profile: ${profile}`);

  // Verify
  const verify = await readConfig(configPath);
  const verifyAws = verify.mcp?.aws;
  if (!verifyAws) {
    throw new Error("Verification failed: mcp.aws block missing after write.");
  }
  console.log("Config verified successfully.");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
