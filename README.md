# devcontainers-dotfiles
Home directory dotfiles for VSCode devcontainers with simplicity in mind.

## Install OpenCode

```
npm install -g opencode-ai npx
opencode --version
```

Update Agent Zero model providers if desired:
```
~/.config/opencode/tools/update-agent-zero-models.ts
```

Enable the AWS MCP server
```
~/.config/opencode/tools/enable-aws-mcp.ts
```

Run `opencode`, then `/connect` to provide the api key for Agent Zero or other provider.  This repo contains config for the agent-zero token service.
