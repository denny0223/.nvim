#!/bin/sh
set -eu

if [ -f "$0" ] && [ -f "$(dirname -- "$0")/init.lua" ]; then
    repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
else
    repo_url=${NVIMRC_REPO:-https://github.com/denny0223/.nvim.git}
    repo_dir=${NVIMRC_DIR:-"$HOME/.nvim"}

    if [ -e "$repo_dir/.git" ]; then
        git -C "$repo_dir" pull --ff-only
    elif [ -e "$repo_dir" ] || [ -L "$repo_dir" ]; then
        echo "$repo_dir already exists and is not a git checkout" >&2
        exit 1
    else
        git clone "$repo_url" "$repo_dir"
    fi
    repo_dir=$(CDPATH= cd -- "$repo_dir" && pwd -P)
fi

if [ ! -f "$repo_dir/init.lua" ]; then
    echo "$repo_dir/init.lua is missing" >&2
    exit 1
fi

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
