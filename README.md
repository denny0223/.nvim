# Denny's Neovim configuration

English | [繁體中文](README.zh-TW.md)

Personal Neovim configuration built with Lua and vim-plug. Feel free to reuse and adapt it to your workflow. Primarily used and tested on Fedora with Kitty and tmux.

## Installation

Requires Neovim 0.12 or later, Git, and curl. Markdown image previews also require Kitty, [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) (`mmdc`), ImageMagick 7 (`magick`), and Chrome or Chromium.

Run the installer:

```sh
curl -fsSL https://nvim.denny.one/install | sh
# or
curl -fsSL https://rc.denny.one/nvim | sh
nvim
```

If the short URLs are unavailable, use the raw file on GitHub:

```sh
curl -fsSL https://raw.githubusercontent.com/denny0223/.nvim/main/setup.sh | sh
```

When run via curl, the installer clones the repository into `~/.nvim` or updates an existing Git checkout with `git pull --ff-only`. If the destination exists but is not a Git checkout, it stops and leaves the existing files untouched. Set `NVIMRC_REPO` and `NVIMRC_DIR` to use a different repository or installation directory; pass these environment variables to `sh` on the right side of the pipe.

Alternatively, clone the repository and install from the local checkout:

```sh
git clone https://github.com/denny0223/.nvim.git ~/.nvim
sh ~/.nvim/setup.sh
nvim
```

The installer backs up any existing configuration and creates a symlink from `${XDG_CONFIG_HOME:-~/.config}/nvim` to this repository. Running `setup.sh` from a local checkout links that checkout directly. Plugins are installed on the first launch; restart Neovim once installation finishes. Plugins are stored in Neovim's XDG data directory, so no existing `~/.vim` or `~/.vimrc` is needed.

Edit `init.lua` to customize editor preferences, plugins, and key mappings. Trailing whitespace is preserved in Markdown files and stripped from other files on save.

## Markdown

Use `\p` or `:MdRender toggle` to switch between source text and a full document preview, including images and Mermaid diagrams. Images initially appear as complete overviews. Press Enter on an image or its caption to open the image view, then use `+`/`-` to zoom, `h/j/k/l` to pan, `0` to reset to the overview, and `q`/`Esc` to return to the document.

Previews use this [md-render.nvim fork](https://github.com/denny0223/md-render.nvim) with the Snacks image backend; vim-plug installs both plugins. Mermaid diagrams are rendered by a browser running in the background, without opening a browser window. The configuration detects `google-chrome` automatically; use `PUPPETEER_EXECUTABLE_PATH` to specify another browser installation. In tmux, enable `set -g allow-passthrough on`.

## Updating and restoring

Run `git -C ~/.nvim pull --ff-only` to update the configuration, then run `:PlugUpdate` in Neovim to update plugins and restart when finished. Plugins follow their repositories' default branches; md-render uses the fork linked above.

To restore your previous configuration, remove the `nvim` symlink created by the installer, then move `nvim` from the backup directory printed by the installer back to its original location.

## Checks

```sh
python3 ~/.nvim/tests/setup.py
nvim --headless -n -i NONE -u ~/.nvim/init.lua -l ~/.nvim/tests/settings.lua
python3 ~/.nvim/tests/install.py
```

The last check downloads plugins into a temporary HOME and verifies the first installation, so it requires network access. Image display still needs to be checked in Kitty/tmux.

Licensed under the [MIT License](LICENSE).
