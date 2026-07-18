# devcontainers-dotfiles
Home directory dotfiles for VSCode devcontainers with simplicity in mind.

## Install OpenCode

```
npm install -g tsx opencode-ai
opencode --version
```

Update Agent Zero model providers if desired:
```
~/.config/opencode/tools/update-agent-zero-models.ts
```

Install uvicorn and other dependencies for the aws mcp server:
```
curl -LsSf https://astral.sh/uv/install.sh | sh
uvx mcp-proxy-for-aws@latest https://aws-mcp.us-east-1.api.aws/mcp --help
```

Enable the AWS MCP server
```
~/.config/opencode/tools/enable-aws-mcp.ts
```

Login to aws with sso
```
aws sso login
```

Run `opencode`, then `/connect` to provide the api key for Agent Zero or other provider.  This repo contains config for the agent-zero token service.
