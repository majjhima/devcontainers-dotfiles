---
name: update-agent-zero-models
description: Use ONLY when the user wants to refresh or update the Agent Zero provider models section in the opencode config at ~/.config/opencode/opencode.json. Fetches current text models from the Venice API (https://docs.venice.ai/models/text), extracts context and output token limits, and writes an updated models block with limit sections for every model.
---

# Update Agent Zero Models

This skill updates the `provider.agent-zero.models` block in the global
opencode config (`~/.config/opencode/opencode.json`) with current text
models from the Venice API. The main purpose is to add missing `limit`
sections (`context` and `output` token caps) that inform opencode of
each model's true capabilities.

> **Note:** Use `node` for all scripting in this workflow. Do **not** rely on
> `python3` — it may not be installed in the environment.

## Workflow

### 1. Fetch current text models from the Venice API

```bash
curl -s https://api.venice.ai/api/v1/models | node -e "
const chunks = [];
process.stdin.on('data', c => chunks.push(c));
process.stdin.on('end', () => {
  const data = JSON.parse(Buffer.concat(chunks).toString());
  const models = Array.isArray(data) ? data : (data.data || []);
  const textModels = models.filter(m => m.type === 'text');
  for (const m of textModels) {
    const spec = m.model_spec || {};
    const ctx = spec.availableContextTokens || '?';
    const out = spec.maxCompletionTokens || '?';
    console.log([m.id, spec.name || m.id, ctx, out].join('|'));
  }
})
```

### 2. Read the existing config and build the updated models block

Use a single `node` script that:
1. Reads `~/.config/opencode/opencode.json`.
2. Parses the API output from Step 1.
3. Builds a new `models` object where each entry has `name` and `limit`.
4. Preserves existing `name` values from the current config.
5. Alphabetically sorts entries by model ID.
6. Writes the updated config back to disk.

Example `node` script:

```js
const fs = require('fs');

const CONFIG_PATH = `${require('os').homedir()}/.config/opencode/opencode.json`;

// Paste the pipe-delimited API output here (one line per model)
const apiOutput = `
<PASTE_STEP_1_OUTPUT_HERE>
`;

const config = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf8'));
const existing = config.provider?.['agent-zero']?.models || {};

const models = {};
for (const line of apiOutput.trim().split('\n').filter(Boolean)) {
  const [id, displayName, ctxStr, outStr] = line.split('|');
  models[id] = {
    name: existing[id]?.name || displayName,
    limit: {
      context: parseInt(ctxStr, 10),
      output: parseInt(outStr, 10)
    }
  };
}

// Sort alphabetically by key
const sortedKeys = Object.keys(models).sort();
const sortedModels = {};
for (const key of sortedKeys) {
  sortedModels[key] = models[key];
}

config.provider['agent-zero'].models = sortedModels;
fs.writeFileSync(CONFIG_PATH, JSON.stringify(config, null, 2) + '\n');
console.log(`Updated ${Object.keys(sortedModels).length} models in ${CONFIG_PATH}`);
```

### 3. Map each model ID to a config entry

For each model, create an entry under `provider.agent-zero.models` in this format:

```json
"<model-id>": {
  "name": "<Human Readable Name>",
  "limit": {
    "context": <availableContextTokens>,
    "output": <maxCompletionTokens>
  }
}
```

Key rules for the `limit` section:

- `context` comes from `model_spec.availableContextTokens`.
- `output` comes from `model_spec.maxCompletionTokens`.
- Both are integers. No quotes. No commas in the numbers.
- **Never invent or hardcode numbers** — always use values returned by the API.
- If a model already exists in the config, **preserve its existing `name`** field and only add/update `limit`.
- If a model in the config no longer appears in the API response, do **not** delete it — just skip it.

### 4. Verify the written config

After writing, re-read the file to confirm valid JSON and that the `models`
block was updated correctly:

```bash
node -e "console.log(JSON.parse(require('fs').readFileSync(require('path').join(require('os').homedir(), '.config/opencode/opencode.json'), 'utf8')).provider['agent-zero'].models)"
```

## Model name mapping

When creating `name` for new models, derive a human-readable name from
`model_spec.name` (the API returns a display name like "DeepSeek V4 Pro").
Strip the provider prefix if present and use sentence case.

## After saving

Remind the user to quit and restart opencode — the running session keeps using
the already-loaded config.
