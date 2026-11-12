vim.opt_local.dictionary = require("config.postgres")
vim.opt_local.complete = { "k" }
vim.opt_local.infercase = true
vim.opt_local.autocomplete = true

-- shortcut: the syntax menu can hide LSP results; use Ctrl-Space until the sources are unified.
vim.keymap.set("i", "<C-Space>", "<C-e><C-x><C-o>", {
  buffer = true,
  desc = "Request SQL completion",
})

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
  .. " | setlocal dictionary< complete< infercase< autocomplete< | silent! iunmap <buffer> <C-Space>"
