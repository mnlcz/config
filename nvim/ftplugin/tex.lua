local map = vim.keymap.set

map("i", "<A-m>", function()
  vim.api.nvim_put({"\\(\\)"}, "c", true, true)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left><Left>", true, false, true), "n", false)
end, { desc = "Insert inline math section", buffer = true })
