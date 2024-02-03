local opt = vim.opt

---------- utilities ---------
local function set_indentation(filetypes, shiftwidth, tabstop)
  for _, ft in ipairs(filetypes) do
    local autocmd_cmd = string.format("setlocal shiftwidth=%d tabstop=%d", shiftwidth, tabstop)
    vim.api.nvim_create_autocmd("FileType", { pattern = ft, command = autocmd_cmd })
  end
end

---------- options ---------
-- appearance
vim.opt.guicursor = "n-v-c-r:hor20,i:ver25"

-- indenting
opt.tabstop = 4
opt.shiftwidth = 4
local custom_indent_rules = {
  { "lua", 2, 2 },
  { "html", 2, 2 },
  { "javascript", 2, 2 },
  { "css", 2, 2 },
}
-- Apply indentation settings for specific file types
for _, settings in ipairs(custom_indent_rules) do
  set_indentation({ settings[1] }, settings[2], settings[3])
end

-- numbers
opt.relativenumber = true

---------- snippets ---------
-- lua format
vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/lua_snippets"
