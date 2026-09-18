# Agent guide

This is Denny's standalone Neovim configuration: Neovim 0.12+, Lua, and vim-plug, primarily used on Fedora with Kitty and tmux. The checkout can be the live configuration through a symlink, so editor changes can affect the next Neovim session.

## Where to work

| Task | Entry point |
| --- | --- |
| Editor options, mappings, autocmds, plugins, Markdown integration | `init.lua` |
| Local and piped installation, updates, backups, config symlink | `setup.sh` |
| Public installer bootstrap and domain | `install`, `CNAME` |
| User-facing setup, dependencies, usage, recovery | `README.md`, `README.zh-TW.md` |

Read the relevant implementation and check below before editing. Keep routine configuration in the existing `init.lua` and use vim-plug; this repository does not need a configuration framework.

## Contracts to preserve

- Inspect `git status --short` and the existing diff first. Before experimenting with the live configuration, identify a restorable Git commit and preserve any uncommitted changes. Commit and push only when requested.
- Neovim is independent of `~/.vim` and `~/.vimrc`. vim-plug and downloaded plugins live under `stdpath("data")`, outside this repository. Do not fix behavior by patching installed plugin copies.
- Markdown uses `denny0223/md-render.nvim` with the Snacks image backend. Renderer implementation changes belong in that fork; configuration belongs here. Keep preview opt-in through `<leader>p` / `:MdRender toggle`, preserve source text, unsaved edits, and cursor position on return, and keep Snacks inline document images disabled.
- Preserve Markdown trailing whitespace on save; it can carry formatting meaning. Other filetypes currently have trailing whitespace removed.
- Keep `setup.sh` and `install` compatible with POSIX `sh`. Local execution links the checkout directly; piped execution clones or updates with `git pull --ff-only` and refuses an existing non-Git destination. Preserve the documented `NVIMRC_REPO`, `NVIMRC_DIR`, and XDG paths, backup-before-replacement behavior, and repeat-install idempotency. Keep installation logic in `setup.sh`; `install` is its download wrapper.
- Test installation with the isolated checks below, rather than repointing the user's active configuration. Keep changes to other personal dotfiles within the user's requested scope.
- Update both READMEs when changing documented behavior, commands, or requirements. Use soft-wrapped Markdown paragraphs. Keep this guide limited to durable project instructions; put usage details in the READMEs.

## Verification

Run commands from the repository root. Choose the checks that cover the change.

For installer changes:

```sh
sh -n setup.sh install
python3 tests/setup.py
```

The Python check uses temporary directories and local Git repositories to cover local/piped installation, updates, backups, refusal of existing non-Git destinations, and idempotency without network access.

For settings, mappings, autocmds, or Markdown integration changes, with plugins already installed:

```sh
nvim --headless -n -i NONE -u ./init.lua -l tests/settings.lua
```

Loading `init.lua` can download vim-plug and install missing plugins. For bootstrap or plugin dependency changes, use the clean-install check instead of relying only on the existing installation:

```sh
python3 tests/install.py
```

This downloads plugins into a temporary HOME with isolated XDG directories and runs the settings check. It needs network access and verifies the local installer, not the published short URLs.

For image or Mermaid preview changes, also verify in actual Kitty with tmux passthrough enabled: source/preview toggle, image overview and zoom/pan, scrolling, pane switching, and resizing. Headless checks and generated PNGs do not establish visible image correctness. Report any unverified display behavior or unavailable dependencies explicitly.

For documentation-only changes, check referenced paths and commands; plugin downloads are unnecessary. Before handoff, review the diff and run:

```sh
git diff --check
```

Report the changed behavior, checks actually run, and remaining verification limits.
