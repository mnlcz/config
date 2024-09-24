require "nvchad.mappings"

local map = vim.keymap.set

-- general
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map("v", ">", ">gv", { desc = "Indent" })

-- extras
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Launch LazyGit" })
map("n", "<leader>mp", "<cmd>Glow<CR>", { desc = "Markdown file preview" })
map("n", "<leader>km", "<cmd>Telescope keymaps<CR>", { desc = "Show keymaps" })
