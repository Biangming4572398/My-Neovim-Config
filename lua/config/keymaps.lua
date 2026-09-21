vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = true },
})

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
  desc = "Show diagnostic details",
})

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
  desc = "List diagnostics for the current file",
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

local brackets = { ["("] = ")", ["["] = "]", ["{"] = "}" }

for opening, closing in pairs(brackets) do
  vim.keymap.set("i", opening, opening .. closing .. "<Left>", {
    desc = "Insert matching " .. closing,
  })

  vim.keymap.set("i", closing, function()
    local column = vim.fn.col(".")
    local next_character = vim.api.nvim_get_current_line():sub(column, column)
    return next_character == closing and "<Right>" or closing
  end, { expr = true, desc = "Skip or insert " .. closing })
end

vim.keymap.set("i", "<BS>", function()
  local column = vim.fn.col(".")
  local line = vim.api.nvim_get_current_line()
  local previous_character = line:sub(column - 1, column - 1)
  local next_character = line:sub(column, column)
  return brackets[previous_character] == next_character and "<BS><Del>" or "<BS>"
end, { expr = true, desc = "Delete empty bracket pair" })
