# Denny 的 Neovim 設定

[English](README.md) | 繁體中文

個人 Neovim 設定，使用 Lua 與 vim-plug，可依自己的習慣複用與調整。主要使用及驗證環境為 Fedora、Kitty 與 tmux。

## 安裝

需要 Neovim 0.12 以上、Git 與 curl。Markdown 圖片預覽另需 Kitty、[Mermaid CLI](https://github.com/mermaid-js/mermaid-cli)（`mmdc`）、ImageMagick 7（`magick`）與 Chrome／Chromium。

使用安裝程式：

```sh
curl -fsSL https://nvim.denny.one/install | sh
# 或
curl -fsSL https://rc.denny.one/nvim | sh
nvim
```

短網址無法使用時，可用 GitHub 原始檔：

```sh
curl -fsSL https://raw.githubusercontent.com/denny0223/.nvim/main/setup.sh | sh
```

下載執行時會將 repo clone 到 `~/.nvim`，已存在的 Git checkout 則以 `git pull --ff-only` 更新；若該路徑已有非 Git 設定，會停止並保留原檔。可用 `NVIMRC_REPO` 與 `NVIMRC_DIR` 環境變數指定其他 repo 與安裝路徑，變數需傳給管線右側的 `sh`。

也可先 clone，再從本機安裝：

```sh
git clone https://github.com/denny0223/.nvim.git ~/.nvim
sh ~/.nvim/setup.sh
nvim
```

安裝程式會把 `${XDG_CONFIG_HOME:-~/.config}/nvim` 連到此 repo，先備份既有設定。從 repo 內執行 `setup.sh` 時會直接連結該 checkout。首次開啟會安裝外掛，完成後重新啟動。外掛存放在 Neovim 的 XDG data 目錄，不需要既有的 `~/.vim` 或 `~/.vimrc`。

`init.lua` 維護編輯偏好、外掛與快捷鍵。儲存時保留 Markdown 的行尾空白，其他檔案會清理行尾空白。

## Markdown

`\p`／`:MdRender toggle` 切換原始碼與整份文件預覽，包含圖片和 Mermaid。圖片先顯示完整概覽；在圖片或其標題上按 Enter 進入圖片頁，`+`／`-` 縮放、`h/j/k/l` 平移、`0` 回復概覽、`q`／`Esc` 返回文件。

使用 [md-render.nvim fork](https://github.com/denny0223/md-render.nvim) 與 Snacks 圖片後端；外掛由 vim-plug 安裝。Mermaid 使用背景瀏覽器轉圖，不會開啟瀏覽器視窗。設定會偵測 `google-chrome`，其他安裝位置可用 `PUPPETEER_EXECUTABLE_PATH` 指定。tmux 需設定 `set -g allow-passthrough on`。

## 更新與還原

執行 `git -C ~/.nvim pull --ff-only` 更新設定，再於 Neovim 執行 `:PlugUpdate` 更新外掛，完成後重新啟動。外掛跟隨各 repo 的預設分支；md-render 使用上述 fork 的版本。

要還原安裝前的設定，移除安裝建立的 `nvim` 符號連結，再將安裝程式印出的備份目錄內的 `nvim` 移回原位。

## 檢查

```sh
python3 ~/.nvim/tests/setup.py
nvim --headless -n -i NONE -u ~/.nvim/init.lua -l ~/.nvim/tests/settings.lua
python3 ~/.nvim/tests/install.py
```

最後一項會在暫存 HOME 下載外掛並檢查首次安裝，需要網路。圖片的實際顯示仍需在 Kitty／tmux 中檢查。

採用 [MIT 授權](LICENSE)。
