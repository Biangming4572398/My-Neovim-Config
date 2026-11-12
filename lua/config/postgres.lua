-- Read keyword definitions directly because syntaxcomplete omits some PostgreSQL functions.
local syntax_file = vim.api.nvim_get_runtime_file("syntax/pgsql.vim", false)[1]
local definitions = {}
for _, line in ipairs(vim.fn.readfile(assert(syntax_file, "PostgreSQL syntax file is missing"))) do
  local words = line:match("^syn keyword sql%w+ (.+)$")
  if words then
    definitions[#definitions + 1] = words:gsub("^contained ", "")
    -- Uppercase entries also match when smartcase is enabled.
    definitions[#definitions + 1] = definitions[#definitions]:upper()
  end
end
assert(#definitions > 0, "PostgreSQL keyword definitions are missing")
-- These words use syntax patterns instead of keyword definitions.
definitions[#definitions + 1] = "create CREATE text TEXT"

local dictionary = vim.fn.stdpath("cache") .. "/postgresql.dict"
vim.fn.mkdir(vim.fn.stdpath("cache"), "p")
vim.fn.writefile(definitions, dictionary)
return dictionary
