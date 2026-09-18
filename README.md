# Denny's Neovim configuration

個人 Neovim 設定，使用 Lua 與 vim-plug，獨立維護於 `~/.nvim`。

## 安裝

將此 repo 放在 `~/.nvim`，再執行：

```sh
bash ~/.nvim/setup.sh
```

安裝程式會把 `${XDG_CONFIG_HOME:-~/.config}/nvim` 連到此 repo，先備份既有設定。首次開啟 `nvim` 安裝外掛後重新啟動。

`init.lua` 維護編輯偏好、外掛列表、快捷鍵與檔案類型設定。外掛放在 Neovim 的 XDG data 目錄，與 `~/.vim` 分開；不需要載入 `~/.vimrc`。

## Markdown

`\p`／`:MdRender toggle` 切換原始碼與整份文件預覽，包含圖片和 Mermaid。圖片先顯示完整概覽；在圖片或其標題上按 Enter 進入 Neovim 圖片頁，`+`／`-` 縮放、`h/j/k/l` 平移、`0` 回復概覽、`q`／`Esc` 返回文件。

md-render.nvim 使用 [denny0223/md-render.nvim](https://github.com/denny0223/md-render.nvim) fork，圖片由 Snacks 顯示。需要 Kitty、`mmdc`、ImageMagick 與 Chrome；在 tmux 中需啟用 `allow-passthrough on`。

## 外掛更新

在 Neovim 執行 `:PlugUpdate` 更新外掛，完成後重新啟動。外掛跟隨各 repo 的預設分支；md-render 使用上述 fork。

## 檢查

```sh
python3 ~/.nvim/tests/setup.py
nvim --headless -n -i NONE -u ~/.nvim/init.lua -l ~/.nvim/tests/settings.lua
python3 ~/.nvim/tests/install.py
```

最後一項會在暫存 HOME 下載外掛並檢查首次安裝，需要網路。
