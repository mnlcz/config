local map = vim.keymap.set
local telescope = require('telescope.builtin')
local lsp = vim.lsp.buf

---------------------------- Main ------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---------------------------- Core ------------------------------
-- Movement
map("i", "<C-l>", "<C-o>l", { desc = "Move right one time" })
map("i", "<C-h>", "<C-o>h", { desc = "Move left one time" })

-- Edition
map("i", "<A-,>", function()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! A;')
  vim.api.nvim_win_set_cursor(0, current_pos)
end, { desc = "Add semicolon at the end and return to position" })
map("i", "<A-CR>", "<Esc>A;<Esc>o", { desc = "Add semicolon at the end and new line" })
map("n", "<A-,>", "A;<Esc>", { desc = "Add semicolon at the end" })
map("i", "<A-a>", "<C-o>$", { desc = "Jump to end of line in insert mode" })
map("i", "<A-i>", "<C-o>_", { desc = "Jump to beginning of line in insert mode" })
map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit insert mode in terminal mode" })

-- Buffers
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close current buffer" })
map("n", "]b", "<cmd>bn<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bp<CR>", { desc = "Previous buffer" })

-- Tabs
map("n", "tt", "<cmd>tabnew<CR>", { desc = "New empty tab" })
map("n", "]t", "<cmd>tabnext<CR>", { desc = "Jumps to next tab" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "Jumps to previous tab" })

-- Spell checker
map("n", "<leader>sc", function() vim.o.spell = not vim.o.spell end, { desc = "Toggle spellcheck" })

-- Dev
map("n", "<leader>r", "<Cmd>:.lua<CR>", { desc = "Run Lua code inline" })

---------------------------- LSP ------------------------------
map("n", "<leader>lf", lsp.format, { desc = "[LSP] Format code" })
map("n", "<leader>la", lsp.code_action, { desc = "[LSP] Code action" })
map("n", "<leader>lh", lsp.hover, { desc = "[LSP] Hover" })
map("n", "<leader>lt", lsp.type_definition, { desc = "[LSP] Jump to type definition" })
map("n", "<leader>ld", lsp.definition, { desc = "[LSP] Jump to symbol definition" })
map("n", "<leader>li", lsp.implementation, { desc = "[LSP] Jump to implementation" })
map("n", "<leader>ls", lsp.signature_help, { desc = "[LSP] Display signature information" })
map("n", "<leader>lr", lsp.references, { desc = "[LSP] Display references" })
map("n", "<leader>lS", lsp.document_symbol, { desc = "[LSP] Display current document symbols" })
map("n", "<leader>lR", lsp.rename, { desc = "[LSP] Rename all references to current symbol" })

---------------------------- Plugins ------------------------------
map("n", "<C-n>", "<cmd>Oil<CR>", { desc = "Open Oil file manager" })
map("n", "<leader>n", require("oil").toggle_float, { desc = "Open Oil file manager as a floating window" })

-- Telescope
map("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
map("n", "<leader>fo", telescope.oldfiles, { desc = "Telescope old files" })
map("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })
map("n", "<leader>km", telescope.keymaps, { desc = "Telescope keymaps" })
map("n", "<leader>fm", telescope.man_pages, { desc = "Telescope man pages" })
map("n", "<leader>fs", telescope.lsp_document_symbols, { desc = "Telescope document symbols" })
map("n", "<leader>fc", telescope.spell_suggest, { desc = "Telescope spell suggestions" })

-- Markdown
-- map("n", "<leader>mp", "<cmd>Glow<CR>", { desc = "Markdown file preview with Glow" })
map("n", "<leader>mr", "<cmd>:RenderMarkdown toggle<CR>", { desc = "Toggle markdown rendering" })
