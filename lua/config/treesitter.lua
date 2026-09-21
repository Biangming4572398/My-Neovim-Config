local parsers = {
  "rust",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "python",
  "javascript",
  "jsdoc",
  "typescript",
  "tsx",
  "markdown",
  "markdown_inline",
}

-- Wait during the one-time bootstrap so a file opened immediately after
-- startup gets Tree-sitter highlighting without needing to be reopened.
require("nvim-treesitter").install(parsers):wait(300000)

local filetypes = {
  "rust",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "python",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "markdown",
}

local group = vim.api.nvim_create_augroup("config.treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = filetypes,
  callback = function(event)
    -- Parser installation is asynchronous on the first launch, so gracefully
    -- retain Neovim's built-in syntax highlighting until it is ready.
    pcall(vim.treesitter.start, event.buf)
  end,
})
