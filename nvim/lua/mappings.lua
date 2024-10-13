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
map("i", "<C-a>", "<C-o>$", { desc = "Jump to end of line in insert mode" })
map("i", "<C-i>", "<C-o>_", { desc = "Jump to beginning of line in insert mode" })
map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })

-- Buffers
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close current buffer" })
map("n", "<leader><Tab>", "<cmd>bn<CR>", { desc = "Next buffer" })
map("n", "<leader><S-Tab>", "<cmd>bp<CR>", { desc = "Previous buffer" })

---------------------------- LSP ------------------------------
map("n", "<leader>fm", lsp.format, { desc = "[LSP] Format code" })
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
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Launch LazyGit" })
map("n", "<leader>mp", "<cmd>Glow<CR>", { desc = "Markdown file preview with Glow" })
map("n", "<C-n>", "<cmd>Oil<CR>", { desc = "Open Oil file manager" })
map("n", "<leader>n", require("oil").toggle_float, { desc = "Open Oil file manager as a floating window" })

-- Neorg
map("n", "<leader>njt", "<cmd>Neorg journal today<CR>", { desc = "[Neorg] Open today's note" })
map("n", "<leader>njy", "<cmd>Neorg journal yesterday<CR>", { desc = "[Neorg] Open yesterday's note" })
map("n", "<leader>nw", "<cmd>Neorg workspace notes<CR>", { desc = "[Neorg] Open main workspace index" })

-- Telescope
map("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
map("n", "<leader>fo", telescope.oldfiles, { desc = "Telescope old files" })
map("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })
map("n", "<leader>km", telescope.keymaps, { desc = "Show keymaps" })

-- nvim-cmp (configured in ./plugins/nvim-cmp.lua)
-- mapping = cmp.mapping.preset.insert({
--   ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--   ['<C-f>'] = cmp.mapping.scroll_docs(4),
--   ['<C-Space>'] = cmp.mapping.complete(),
--   ['<C-e>'] = cmp.mapping.abort(),
--   ['<CR>'] = cmp.mapping.confirm({ select = true }),
-- }),
