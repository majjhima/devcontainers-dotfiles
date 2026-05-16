#!/bin/bash
set -ex

sudo apt -y update
sudo apt -y dist-upgrade
sudo apt -y --no-install-recommends install jq tmux vim zsh

# Get the path of zsh
ZSH_PATH=$(which zsh)

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Copy dotfiles
rsync -av "$SCRIPT_DIR/" "$HOME/"

# Change the default shell to zsh
sudo chsh -s "$ZSH_PATH" "$USER"

# Opencode base config
OPENCODE_DIR="${HOME}/.config/opencode/"
rsync -av "$SCRIPT_DIR/.devcontainer/opencode/" "$OPENCODE_DIR"

# Start a detached tmux session
tmux new -s vscode -d
