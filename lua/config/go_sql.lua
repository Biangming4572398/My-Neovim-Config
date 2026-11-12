local M = {}
local words = vim.split(table.concat(vim.fn.readfile(require("config.postgres")), " "), "%s+")
local statements = {
  select = true,
  with = true,
  insert = true,
  update = true,
  delete = true,
  create = true,
  alter = true,
  drop = true,
  truncate = true,
  explain = true,
}

function M.complete(findstart, base)
  if findstart == 1 then
    local cursor = vim.api.nvim_win_get_cursor(0)
    local node = vim.treesitter.get_node({
      pos = { cursor[1] - 1, math.max(cursor[2] - 1, 0) },
      ignore_injections = true,
    })
    if not node
      or not vim.tbl_contains({ "raw_string_literal_content", "interpreted_string_literal_content" }, node:type())
    then
      return -3
    end

    local parent = node:parent()
    local text = vim.treesitter.get_node_text(node, 0)
    if parent and vim.tbl_contains({ "raw_string_literal", "interpreted_string_literal" }, parent:type()) then
      text = vim.treesitter.get_node_text(parent, 0):sub(2)
    elseif node:type() == "interpreted_string_literal_content" then
      -- Unfinished quoted strings can have separate content nodes around escapes.
      local previous = node:prev_sibling()
      while previous
        and vim.tbl_contains({ "interpreted_string_literal_content", "escape_sequence" }, previous:type())
      do
        text = vim.treesitter.get_node_text(previous, 0) .. text
        previous = previous:prev_sibling()
      end
    end
    if node:type() == "interpreted_string_literal_content" then
      text = text:gsub("\\[nrt]", " ")
    end
    text = text:lower()
    -- shortcut: detection uses SQL prefixes; use an SQL parser if non-SQL strings also match.
    if not text:match("^%s*%-%-%s*sql%f[%A]") and not statements[text:match("^%s*(%a+)")] then
      return -3
    end
    return vim.fn.match(vim.api.nvim_get_current_line():sub(1, cursor[2]), [[\k*$]])
  end
  return vim.fn.matchfuzzy(words, base)
end

return M
