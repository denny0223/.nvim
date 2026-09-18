#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
config_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}
target=$config_dir/nvim

if [ -L "$target" ] && [ "$(readlink "$target")" = "$repo_dir" ]; then
    echo "Neovim configuration is already linked."
    exit 0
fi

mkdir -p "$config_dir"
if [ -e "$target" ] || [ -L "$target" ]; then
    backup=$(mktemp -d "$config_dir/nvim.backup.XXXXXX")
    mv "$target" "$backup/nvim"
    echo "Backed up existing Neovim configuration to $backup/nvim"
fi

ln -s "$repo_dir" "$target"
echo "Installed Neovim configuration. Open nvim to install plugins."
