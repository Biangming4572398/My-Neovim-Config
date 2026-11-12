local plugins = {
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://codeberg.org/lifepillar/pgsql.vim" },
}

-- Neovim 0.12's built-in package manager records exact revisions in
-- nvim-pack-lock.json. Initial installation is non-interactive.
vim.pack.add(plugins, { confirm = false })
