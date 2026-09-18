-- Run from this repository with: nvim --headless -n -i NONE -u init.lua -l tests/settings.lua
local function check()
  local function equal(actual, expected)
    assert(vim.deep_equal(actual, expected), vim.inspect({ actual = actual, expected = expected }))
  end

  equal(vim.o.number, true)
  equal(vim.o.tabstop, 4)
  equal(vim.o.shiftwidth, 4)
  equal(vim.fn.maparg("<C-p>", "n"), "<Cmd>Files<CR>")
  equal(vim.fn.maparg("<leader>s", "n"), ":Rg ")
  equal(vim.fn.maparg("gd", "n"), "<Plug>(ale_go_to_definition)")
  equal(vim.fn.exists(":PlugInstall"), 2)
  equal(vim.fn.exists(":Files"), 2)
  assert(not vim.o.runtimepath:find(vim.fn.expand("~/.vim"), 1, true))
  for _, plugin in pairs(vim.g.plugs) do
    assert(vim.fn.isdirectory(plugin.dir) == 1, "Missing plugin: " .. plugin.dir)
  end

  for _, ft in ipairs({ "html", "javascript", "json", "yaml", "python" }) do
    vim.cmd.enew()
    vim.bo.filetype = ft
    local width = ft == "python" and 4 or 2
    equal(vim.bo.tabstop, width)
    equal(vim.bo.shiftwidth, width)
    equal(vim.bo.softtabstop, width)
    equal(vim.bo.expandtab, true)
  end
  equal(vim.wo.colorcolumn, "100")
  equal(vim.b.ale_linters, { "ruff", "pyright" })
  equal(vim.b.ale_fixers, { "ruff", "ruff_format" })
  equal(vim.bo.omnifunc, "ale#completion#OmniFunc")

  vim.cmd.enew()
  vim.bo.filetype = "gitcommit"
  equal(vim.wo.spell, true)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "trailing spaces  ", "tab\t", "unchanged" })
  vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
  equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "trailing spaces", "tab", "unchanged" })
  vim.bo.modified = false

  equal(vim.fn.exists(":MdRender"), 2)
  equal(vim.fn.maparg("<leader>p", "n"), "<Cmd>MdRender toggle<CR>")
  vim.cmd.enew()
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# Preview", "", "Unsaved content" })
  local source = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_cursor(0, { 3, 4 })
  vim.cmd("MdRender toggle")
  assert(vim.api.nvim_get_current_buf() ~= source)
  equal(vim.bo.modifiable, false)
  equal(vim.fn.maparg("<leader>p", "n"), "<Cmd>MdRender toggle<CR>")
  vim.cmd("MdRender toggle")
  equal(vim.api.nvim_get_current_buf(), source)
  equal(vim.api.nvim_win_get_cursor(0)[1], 3)
  equal(vim.api.nvim_buf_get_lines(0, 2, 3, false), { "Unsaved content" })
  equal(vim.bo.modified, true)
  vim.bo.modified = false
  vim.cmd.enew()
  vim.bo.filetype = "markdown"
  local markdown = { "first line  ", "second line", "", "```text", "example  ", "```" }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, markdown)
  vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
  equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), markdown)
  vim.bo.modified = false

  print("Personal Neovim settings and Markdown preview mapping OK")
end

local ok, err = pcall(check)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd("cquit 1")
end
