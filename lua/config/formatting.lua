local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    rust = { "rustfmt", lsp_format = "fallback" },
    go = { "goimports", "gofmt" },
    python = { "ruff_format" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    markdown = { "prettier" },
  },
  default_format_opts = {
    lsp_format = "fallback",
    timeout_ms = 2000,
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { bufnr = bufnr }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(arguments)
  if arguments.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable format-on-save globally; use ! for this buffer",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Enable format-on-save" })

vim.keymap.set({ "n", "x" }, "<leader>f", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file or selection" })
