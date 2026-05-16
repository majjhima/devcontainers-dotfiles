# AGENTS.md

## What this repo is

A dotfiles repo for VS Code devcontainers. The **repo root IS the home-directory source**; `install.sh` rsyncs the entire root to `$HOME`.

## Install / deploy

```bash
./install.sh
```

This:
1. Installs `jq tmux vim zsh`
2. `rsync -av` the repo root → `$HOME`
3. Sets zsh as the default shell
4. Starts a detached tmux session named `vscode`

## OpenCode config

Source files: `.devcontainer/opencode/` — deployed to `~/.config/opencode/` by `install.sh`.

Tools (TypeScript, run with `npx tsx`):
- `tools/update-agent-zero-models.ts` — fetches current Venice text models and writes them to `provider.agent-zero.models` in the global opencode config
- `tools/enable-aws-mcp.ts` — enables the AWS MCP server block in the global opencode config

Both tools default to `~/.config/opencode/opencode.json`. The deployed config is the one that matters; edit the source under `.devcontainer/opencode/` only if you want changes to survive reinstall.

## Optional environment

`.zshenv-*` sets project specific optional environment variables such as:
- `AWS_REGION`
- `AWS_PROFILE`

These can be provided by other repos and are sourced by `.zshenv` via the glob `for zshenv in $HOME/.zshenv-*(N)`.

## Shell conventions

- **tmux prefix**: `C-a` (not `C-b`)
- **zsh**: vi keybindings (`bindkey -v`); extensive history settings including `SHARE_HISTORY`
- **aliases**: sourced from `~/.aliases*` — `.aliases` is the base set
- **git**: `.gitconfig` includes `.gitconfig-common` which defines many aliases (`st`, `ci`, `up`, `lg`, `ll`, etc.)

## What is / isn’t tracked

`.gitignore` excludes most runtime and secret files: `.ssh/`, `.aws/`, `.config/`, `.local/`, `.gnupg/`, `.cache/`, `.nvm/`, `.npm/`, `.vscode*/`, `.zcompdump*`, `.zsh_history*`, etc.

`.rsync-filter` and `.diff-exclude` exclude local-only files (`- .aliases-*`, `- .zshenv-*`, `- .git*`, `- .ssh`) from the rsync / diff workflow.

## Devcontainer

`devcontainer.json` uses `mcr.microsoft.com/devcontainers/base:ubuntu`. No custom features or post-create scripts beyond `install.sh`.
