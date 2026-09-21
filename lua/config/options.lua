local options = {
  number = true,
  relativenumber = true,
  mouse = "a",
  breakindent = true,
  undofile = true,
  ignorecase = true,
  smartcase = true,
  signcolumn = "yes",
  updatetime = 250,
  timeoutlen = 400,
  splitright = true,
  splitbelow = true,
  termguicolors = true,
  completeopt = "menuone,noselect,popup,fuzzy",
}

for name, value in pairs(options) do
  vim.opt[name] = value
end

vim.opt.shortmess:append("I")
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Keep indentation defaults predictable; language-specific ftplugins can
-- override these values when a buffer is opened.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
