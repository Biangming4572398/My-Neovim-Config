-- Run: nvim --headless -i NONE -c 'luafile tests/go_sql_completion.lua'
local ok, err = pcall(function()
  vim.opt.virtualedit = "onemore"
  vim.cmd("enew")
  vim.bo.filetype = "go"
  local complete = require("config.go_sql").complete

  local function check(source, expected)
    local marker = assert(source:find("|", 1, true))
    local before = source:sub(1, marker - 1)
    local lines = vim.split(source:sub(1, marker - 1) .. source:sub(marker + 1), "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    local row = select(2, before:gsub("\n", "")) + 1
    local column = #(before:match("[^\n]*$") or "")
    vim.api.nvim_win_set_cursor(0, { row, column })
    vim.treesitter.get_parser(0, "go"):parse(true)
    local start = complete(1, "")
    assert((start >= 0) == expected, "Unexpected SQL detection: " .. source)
    if expected then
      assert(start <= column, "Completion starts after the cursor")
    end
  end

  check("package main\nvar query = `SELECT jsonb_build_o|`", true)
  check('package main\nvar query = "SELECT jsonb_build_o|"', true)
  check('package main\nvar query = "SELECT id\\nFROM use|"', true)
  check("package main\nvar query = `-- sql\nSEL|`", true)
  check("package main\nvar query = `-- sql\nSEL|", true)
  check('package main\nvar query = "SELECT jsonb_build_o|', true)
  check('package main\nvar query = "SELECT id\\nFROM use|', true)
  check('package main\nvar query = "-- sql\\nSEL|', true)
  check('package main\nvar query = "SELECT \\"jsonb_build_o|', true)
  check('package main\nvar query = "\\n\\tSELECT jsonb_build_o|"', true)
  check("package main\nvar query = `WITH records AS (SELECT 1) SEL|`", true)
  check("package main\nvar message = `hello wor|`", false)
  check('package main\nvar message = "hello wor|"', false)
  check('package main\nvar message = "plain text\\nSELECT|', false)
  check('package main\nvar message = "SELECT 1" + "hello wor|', false)
  check("package main\nvar message = `\\nSELECT jsonb_build_o|`", false)
  check("package main\n// SELECT jsonb_build_o|", false)
  check("package main\nfunc main() { fmt.Pr| }", false)
  check("package main\nvar query = `SELECT 1`|", false)

  assert(vim.tbl_contains(complete(0, "jsonb_build_o"), "jsonb_build_object"))
  assert(vim.tbl_contains(complete(0, "CRE"), "CREATE"))

  vim.bo.filetype = "text"
  assert(not vim.bo.autocomplete, "SQL completion remains active in text files")
  assert(vim.bo.completefunc == "", "SQL completion function was not removed")
  vim.bo.filetype = "sql"
  assert(vim.fn.filereadable(vim.bo.dictionary) == 1, "SQL dictionary is missing")
  assert(vim.bo.autocomplete, "SQL file completion is disabled")
end)

for _, client in ipairs(vim.lsp.get_clients()) do
  client:stop(true)
end
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
print("PASS: embedded PostgreSQL completion, non-SQL isolation, and filetype cleanup")
vim.cmd("qa!")
