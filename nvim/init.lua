local opt = vim.opt

---------- options ---------
-- indenting
opt.tabstop = 4
opt.shiftwidth = 4

-- numbers
opt.relativenumber = true

---------- snippets ---------
-- lua format 
vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/lua_snippets"

