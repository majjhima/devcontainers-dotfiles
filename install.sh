#!/bin/sh

sudo apt -y update
sudo apt -y dist-upgrade
sudo apt -y --no-install-recommends install vim tmux

# Check if zsh is installed and do nothing if not
if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh is not installed. Please install zsh and rerun this script."
  exit 1
fi

# Get the path of zsh
ZSH_PATH=$(which zsh)

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Copy dotfiles
rsync -av "$SCRIPT_DIR/" "$HOME/"

# Initialize submodules
cd "$HOME" || exit 1

# Change the default shell to zsh
sudo chsh -s "$ZSH_PATH" "$USER"

# Check if the shell was changed successfully
if [ $? -eq 0 ]; then
  echo "Successfully changed the default shell to zsh."
  echo "Please log out and log back in for the changes to take effect."
else
  echo "Failed to change the default shell."
  exit 1
fi

# Start a detached tmux session
tmux new -s vscode -d
