vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/bettervim/yugen.nvim" },
})

-- No config
require("mini.icons").setup()
require("oil").setup()
require("telescope").setup()
require("yugen").setup()

-- Config
require("nvim-autopairs").setup({
  event = "InsertEnter",
  config = true,
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    tex = { "latexindent" },
  },
})

require("gitsigns").setup({ signcolumn = false })
