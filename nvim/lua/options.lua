local os_utils = require("custom_tools.get_os")
local current_os = os_utils.get_current_os()

---------------------------- Shell ----------------------------
if current_os == "windows" then vim.opt.shell = "pwsh" end

------------------------ Appearance ---------------------------
vim.cmd.colorscheme("yugen")
vim.opt.winborder = "rounded" -- Default border for floating windows

--------------------------- Lines -----------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

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
  { "json",       2, 2 },
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
vim.opt.laststatus = 3       -- Global status line (instead of one per window)
vim.opt.swapfile = false     -- Disable swap file
vim.opt.listchars = "tab: ,multispace:|   ,eol:󰌑" -- Characters to show for tabs, spaces, and end of line
vim.opt.list = true -- Show whitespace characters
vim.opt.hlsearch = false -- Disable highlighting of results
vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

