------------------------ Appearance ---------------------------
vim.cmd.colorscheme("yugen")
vim.opt.winborder = "rounded" -- Default border for floating windows

--------------------------- Lines -----------------------------
vim.opt.number = true
vim.opt.relativenumber = true

--------------------------- Split -----------------------------
vim.opt.splitbelow = true -- Split vertical default to below
vim.opt.splitright = true -- Split horizontal default to right

------------------------- Indenting ---------------------------
vim.opt.expandtab = true -- Tabs into spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4   -- Size for << and >> indentation

-- Dynamic indentation rules
local function set_indentation(filetypes, shiftwidth, tabstop)
  for _, ft in ipairs(filetypes) do
    local autocmd_cmd = string.format("setlocal shiftwidth=%d tabstop=%d", shiftwidth, tabstop)
    vim.api.nvim_create_autocmd("FileType", { pattern = ft, command = autocmd_cmd })
  end
end

-- Rules
local custom_indent_rules = {
  { "lua",        2, 2 },
  { "html",       2, 2 },
  { "javascript", 2, 2 },
  { "css",        2, 2 },
}

-- Apply indentation settings for specific file types
for _, settings in ipairs(custom_indent_rules) do
  set_indentation({ settings[1] }, settings[2], settings[3])
end

--------------------------- Moves -----------------------------
vim.opt.virtualedit = "block" -- Makes empty character cells available in block mode

-------------------------- Edition ----------------------------
vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.inccommand = "split"      -- Show command output preview in different buffer

---------------------------- QOL ------------------------------
vim.opt.ignorecase = true    -- Ignore case for command autocomplete ease of use
vim.opt.termguicolors = true -- Enables more colors for modern terminals
vim.opt.laststatus = 3 -- Global status line (instead of one per window)

-------------------------- Snippet ----------------------------
vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/lua_snippets"
