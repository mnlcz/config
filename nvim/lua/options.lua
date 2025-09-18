local os_utils = require("custom_tools.get_os")
local current_os = os_utils.get_current_os()

---------------------------- Shell ----------------------------
if current_os == "windows" then vim.o.shell = "pwsh" end

------------------------ Appearance ---------------------------
vim.cmd.colorscheme("base16-black-metal-venom")
vim.o.winborder = "rounded" -- Default border for floating windows
vim.o.guicursor =
"n-v-c-i-ci-ve-r-cr:hor30,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"


--------------------------- Lines -----------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false

--------------------------- Split -----------------------------
vim.o.splitbelow = true -- Split vertical default to below
vim.o.splitright = true -- Split horizontal default to right

------------------------- Indenting ---------------------------
vim.o.expandtab = true -- Tabs into spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4   -- Size for << and >> indentation

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
vim.o.virtualedit = "block" -- Makes empty character cells available in block mode

-------------------------- Edition ----------------------------
vim.o.clipboard = "unnamedplus" -- System clipboard
vim.o.inccommand = "split"      -- Show command output preview in different buffer

---------------------------- QOL ------------------------------
vim.o.ignorecase = true -- Ignore case for command autocomplete ease of use
vim.o.termguicolors = true -- Enables more colors for modern terminals
vim.o.laststatus = 3 -- Global status line (instead of one per window)
vim.o.swapfile = false -- Disable swap file
vim.o.listchars = "tab: ,multispace:|   ,eol:󰌑" -- Characters to show for tabs, spaces, and end of line
vim.o.list = true -- Show whitespace characters
vim.o.hlsearch = false -- Disable highlighting of results
vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation
