vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.plugins")
require("config.treesitter")
require("config.lsp")
require("config.formatting")
require("config.keymaps")

vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, "@keyword", { fg = "#c678dd", bold = true })
vim.api.nvim_set_hl(0, "@variable", { fg = "#61afef", bold = false })
vim.api.nvim_set_hl(0, "@lsp.type.keyword", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "@variable" })

vim.api.nvim_set_hl(0, "@function", { fg = "#e5c07b" })
vim.api.nvim_set_hl(0, "@function.call", { link = "@function" })
vim.api.nvim_set_hl(0, "@function.method", { link = "@function" })
vim.api.nvim_set_hl(0, "@function.method.call", { link = "@function" })

vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "@function" })
vim.api.nvim_set_hl(0, "@lsp.type.method", { link = "@function" })

-- Types: teal
vim.api.nvim_set_hl(0, "@type", { fg = "#56b6c2" })
vim.api.nvim_set_hl(0, "@type.builtin", { link = "@type" })

vim.api.nvim_set_hl(0, "@lsp.type.type", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.enum", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.struct", { link = "@type" })

-- Actual built-in functions
vim.api.nvim_set_hl(0, "@function.builtin", { link = "@function" })

-- Constants: orange
vim.api.nvim_set_hl(0, "@constant", { fg = "#d19a66" })
vim.api.nvim_set_hl(0, "@constant.builtin", { link = "@constant" })
vim.api.nvim_set_hl(0, "@lsp.type.const", { link = "@constant" })
vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { link = "@constant" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly", { link = "@constant" })

-- Crate/module names, e.g. std::io: green
vim.api.nvim_set_hl(0, "@module", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "@module.builtin", { link = "@module" })
vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "@module" })
