vim.opt_local.completefunc = "v:lua.require'config.go_sql'.complete"
vim.opt_local.complete = { "F" }
vim.opt_local.autocomplete = true

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal completefunc< complete< autocomplete<"
