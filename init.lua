-- Personal Neovim configuration; maintained in ~/.nvim.
-- Keep the familiar Vim workflow and use vim-plug for both Vimscript and Lua plugins.
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.cursorline = true
vim.opt.showcmd = true
vim.opt.hlsearch = true
vim.opt.history = 1000
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.wildignorecase = true
vim.opt.backspace = { "indent", "eol", "start" }

-- Preserve existing Vim mappings.
vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<bar>diffupdate<cr><C-l>")
vim.keymap.set("n", "<C-p>", "<cmd>Files<cr>", { silent = true })
vim.keymap.set("n", "<leader>s", ":Rg ")
vim.keymap.set("n", "gd", "<Plug>(ale_go_to_definition)", { remap = true })

-- Set plugin variables before vim-plug loads the plugins.
vim.g.ale_completion_enabled = 1
vim.g.closetag_filetypes = "html,xhtml,phtml"
vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml"
vim.g.copilot_filetypes = { gitcommit = true }

if vim.fn.executable("fd") == 1 then
  vim.env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"
elseif vim.fn.executable("fdfind") == 1 then
  vim.env.FZF_DEFAULT_COMMAND = "fdfind --type f --hidden --follow --exclude .git"
end

local group = vim.api.nvim_create_augroup("denny_nvim", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  command = [[if &l:filetype !=# 'markdown' | %s/\s\+$//e | endif]],
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "html", "javascript", "json", "yaml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.colorcolumn = "100"
    vim.b.ale_linters = { "ruff", "pyright" }
    vim.b.ale_fixers = { "ruff", "ruff_format" }
    vim.opt_local.omnifunc = "ale#completion#OmniFunc"
  end,
})

-- Keep downloaded plugins outside the configuration repository and separate from Vim.
local data = vim.fn.stdpath("data")
local plug_path = data .. "/site/autoload/plug.vim"
if vim.fn.filereadable(plug_path) == 0 then
  local download = vim.system({
    "curl", "--fail", "--silent", "--show-error", "--location",
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  }, { text = true }):wait()
  if download.code ~= 0 then
    vim.notify("Could not install vim-plug: " .. download.stderr, vim.log.levels.ERROR)
    return
  end
  vim.fn.mkdir(vim.fn.fnamemodify(plug_path, ":h"), "p")
  vim.fn.writefile(vim.split(download.stdout, "\n", { plain = true }), plug_path)
end

vim.cmd.source(plug_path)
vim.fn["plug#begin"](data .. "/plugged")
local Plug = vim.fn["plug#"]
Plug("alvan/vim-closetag")
Plug("junegunn/fzf", { ["do"] = function() vim.fn["fzf#install"]() end })
Plug("junegunn/fzf.vim")
Plug("easymotion/vim-easymotion")
Plug("tpope/vim-surround")
Plug("hotoo/pangu.vim")
Plug("dense-analysis/ale")
Plug("github/copilot.vim")
Plug("delphinus/md-render.nvim", { tag = "v3.10.0" })
vim.fn["plug#end"]()

for _, plugin in pairs(vim.g.plugs) do
  if vim.fn.isdirectory(plugin.dir) == 0 then
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      once = true,
      callback = function()
        vim.cmd("PlugInstall --sync")
        vim.notify("Check :PlugStatus, then restart Neovim to load the installed plugins.")
      end,
    })
    return
  end
end

-- Separate document preview; source buffers remain ordinary Markdown.
if not vim.env.PUPPETEER_EXECUTABLE_PATH and vim.fn.executable("google-chrome") == 1 then
  vim.env.PUPPETEER_EXECUTABLE_PATH = vim.fn.exepath("google-chrome")
end
vim.keymap.set("n", "<leader>p", "<Cmd>MdRender toggle<CR>", { desc = "Toggle Markdown preview" })
