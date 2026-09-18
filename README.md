# Denny's Neovim configuration

Neovim 的 Vim 相容設定，沿用 `~/.vimrc`、`~/.vim` 的外掛與檔案類型設定。

## 安裝

先準備既有的 `~/.vim` 設定與 `~/.vimrc` 連結，再將此 repo 放在 `~/.nvim`，執行：

```sh
bash ~/.nvim/setup.sh
```

安裝程式會把 `${XDG_CONFIG_HOME:-~/.config}/nvim` 連到此 repo，先備份既有設定。外掛維持由既有的 Vim 設定管理。

## 檢查

```sh
python3 ~/.nvim/tests/setup.py
nvim --headless -n -i NONE -u ~/.nvim/init.vim -l ~/.nvim/tests/settings.lua
```
