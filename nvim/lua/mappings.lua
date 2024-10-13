local map = vim.keymap.set
local telescope = require('telescope.builtin')

---------------------------- Main ------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---------------------------- Buffers ------------------------------
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close current buffer" })

---------------------------- Telescope ------------------------------
map("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
map("n", "<leader>fo", telescope.oldfiles, { desc = "Telescope old files" })
map("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })
map("n", "<leader>km", telescope.keymaps, { desc = "Show keymaps" })

---------------------------- LSP ------------------------------
map("n", "<leader>fm", vim.lsp.buf.format, { desc = "Format code" })

---------------------------- Plugins ------------------------------
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Launch LazyGit" })
map("n", "<leader>mp", "<cmd>Glow<CR>", { desc = "Markdown file preview with Glow" })
map("n", "-", "<cmd>Oil<CR>", { desc = "Open Oil file manager" })
map("n", "<leader>-", require("oil").toggle_float, { desc = "Open Oil file manager as a floating window" })

-- Neorg
map("n", "<leader>njt", "<cmd>Neorg journal today<CR>", { desc = "[Neorg] Open today's note" })
map("n", "<leader>njy", "<cmd>Neorg journal yesterday<CR>", { desc = "[Neorg] Open yesterday's note" })
map("n", "<leader>nw", "<cmd>Neorg workspace notes<CR>", { desc = "[Neorg] Open main workspace index" })
