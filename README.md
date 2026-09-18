# Denny's Neovim configuration

個人 Neovim 設定，使用 Lua 與 vim-plug，獨立維護於 `~/.nvim`。

## 安裝

將此 repo 放在 `~/.nvim`，再執行：

```sh
bash ~/.nvim/setup.sh
```

安裝程式會把 `${XDG_CONFIG_HOME:-~/.config}/nvim` 連到此 repo，先備份既有設定。首次開啟 `nvim` 安裝外掛後重新啟動。

`init.lua` 維護編輯偏好、外掛列表、快捷鍵與檔案類型設定。外掛放在 Neovim 的 XDG data 目錄，與 `~/.vim` 分開；不需要載入 `~/.vimrc`。

## 檢查

```sh
python3 ~/.nvim/tests/setup.py
nvim --headless -n -i NONE -u ~/.nvim/init.lua -l ~/.nvim/tests/settings.lua
```
