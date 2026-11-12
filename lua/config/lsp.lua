local servers = {
  "rust_analyzer",
  "gopls",
  "basedpyright",
  "ruff",
  "ts_ls",
  "marksman",
  "postgres_lsp",
  "yamlls",
}

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_enable = servers,
})

-- mason-lspconfig owns language-server installation. This plugin only owns
-- standalone formatters that are not included in a language toolchain.
require("mason-tool-installer").setup({
  ensure_installed = {
    "goimports",
    "prettier",
  },
  run_on_start = true,
  auto_update = false,
  start_delay = 1000,
  debounce_hours = 24,
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true,
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      analyses = {
        nilness = true,
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      inlayHints = {
        closureReturnTypeHints = { enable = "with_block" },
        lifetimeElisionHints = { enable = "skip_trivial" },
      },
    },
  },
})

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
      },
    },
  },
})

local group = vim.api.nvim_create_augroup("config.lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local function map(lhs, rhs, description)
      vim.keymap.set("n", lhs, rhs, {
        buffer = event.buf,
        desc = "LSP: " .. description,
      })
    end

    map("gd", vim.lsp.buf.definition, "go to definition")
    map("gD", vim.lsp.buf.declaration, "go to declaration")
    map("grr", vim.lsp.buf.references, "find references")
    map("K", vim.lsp.buf.hover, "hover documentation")
    map("<leader>rn", vim.lsp.buf.rename, "rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "code action")
    map("<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), {
        bufnr = event.buf,
      })
    end, "toggle inlay hints")

    if client:supports_method("textDocument/completion") then
      -- Also open completion while typing identifiers, keeping server triggers.
      local triggers = client.server_capabilities.completionProvider.triggerCharacters or {}
      for char in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"):gmatch(".") do
        if not vim.tbl_contains(triggers, char) then
          triggers[#triggers + 1] = char
        end
      end
      client.server_capabilities.completionProvider.triggerCharacters = triggers
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })

      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if vim.fn.pumvisible() == 1 then
          return "<C-n>"
        elseif vim.snippet.active({ direction = 1 }) then
          return "<Cmd>lua vim.snippet.jump(1)<CR>"
        end
        return "<Tab>"
      end, { buffer = event.buf, expr = true, silent = true, desc = "Next completion or snippet field" })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if vim.fn.pumvisible() == 1 then
          return "<C-p>"
        elseif vim.snippet.active({ direction = -1 }) then
          return "<Cmd>lua vim.snippet.jump(-1)<CR>"
        end
        return "<S-Tab>"
      end, { buffer = event.buf, expr = true, silent = true, desc = "Previous completion or snippet field" })

      vim.keymap.set("i", "<CR>", function()
        if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected >= 0 then
          return "<C-y>"
        end
        return "<CR>"
      end, { buffer = event.buf, expr = true, desc = "Accept selected completion or insert newline" })
    end
  end,
})

vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, {
  desc = "Trigger LSP completion",
})
