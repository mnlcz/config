local os_utils = require("custom_tools.get_os")
local current_os = os_utils.get_current_os()

vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/onsails/lspkind.nvim" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/SCJangra/table-nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" }, -- NOT WORKING
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/lervag/vimtex" },
  -- { src = "https://github.com/folke/which-key.nvim" }, -- Not working for me on nvim unstable
  -- { src = "https://github.com/metalelf0/black-metal-theme-neovim" },
  { src = "https://github.com/oskarnurm/koda.nvim" },
})

-- No config
require("mini.icons").setup()
require("oil").setup()
require("todo-comments").setup()

-- Config
require("telescope").setup()
-- require("telescope").load_extension("fzf") -- NOT WORKING
-- require("telescope").load_extension("dap") -- NOT WORKING

require("nvim-autopairs").setup({
  event = "InsertEnter",
  config = true,
})

require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    markdown = { "prettier" },
    lua = { "stylua" },
    -- tex = { "latexindent" }, -- Using vimtex
  },
})

require("gitsigns").setup({ signcolumn = false })

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "html", "css", "javascript",
    "json", "php", "http", "python", "c_sharp", "rust", "gitignore", "yaml", "xml", "java" },
  auto_install = true,
  ignore_install = { "latex" }, -- Does not support ABI 15 (at least for now in unstable)
  sync_install = false,
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Leader>ss",    -- Start selection
      node_incremental = "<Leader>si",  -- Selection increment
      scope_incremental = "<Leader>sc", -- Scope increment
      node_decremental = "<Leader>sd",  -- Selection decrement
    },
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        ["ii"] = "@conditional.inner",
        ["ai"] = "@conditional.outer",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
      },

      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V',  -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },

      include_surrounding_whitespace = true,
    },
  },
})

-- require("which-key").setup({
--   keys = {
--     {
--       "<leader>?",
--       function()
--         require("which-key").show({ global = false })
--       end,
--       desc = "Buffer Local Keymaps (which-key)",
--     },
--   }
-- })

require("table-nvim").setup({
  ft = "markdown, norg"
})

require("render-markdown").setup({
  enabled = false,
  completions = {
    lsp = {
      enabled = true,
    },
  },
  code = {
    style = 'language',
  },
})

require("lspkind").setup({
  mode = "symbol_text",
  preset = "codicons"
})

require("luasnip").setup()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

-- VIMTEX
vim.g.vimtex_view_general_viewer = current_os == "windows" and "sioyek" or "sioyek" -- change if needed
vim.g.vimtex_compiler_latexmk = {
  out_dir = "build",
}
vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- conflicts with LSP mapping
