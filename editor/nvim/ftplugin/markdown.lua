local map = vim.keymap.set

map("n", "<leader>mb", "<Esc>bi**<Esc>ea**<Esc>", { desc = "Markdown make word bold" })
map("n", "<leader>mi", "<Esc>bi*<Esc>ea*<Esc>", { desc = "Markdown make word italic" })
