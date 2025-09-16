local os_utils = require("custom_tools.get_os")
local current_os = os_utils.get_current_os()

vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/SCJangra/table-nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/xiyaowong/transparent.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  {
    src = "https://github.com/lervag/vimtex",
    -- Configuring it here works? Idk...
    ft = "plaintex",
    config = function()
      vim.g.vimtex_view_general_viewer = current_os == "windows" and "sioyek" or "zathura"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
      }
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- conflicts with LSP mapping
    end
  },
  -- { src = "https://github.com/folke/which-key.nvim" }, -- Not working on nvim unstable
  { src = "https://github.com/bettervim/yugen.nvim" },
})

-- No config
require("mini.icons").setup()
require("oil").setup()
require("telescope").setup()
require("todo-comments").setup()

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

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "html", "css", "javascript",
    "json", "php", "http", "python", "c_sharp", "rust", "gitignore", "yaml", "xml", "java" },
  auto_install = true,
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

require("transparent").setup({
  require("transparent").setup({
    groups = {
      'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
      'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
      'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
      'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
      'EndOfBuffer',
    },
    extra_groups = {},
    exclude_groups = {},
    on_clear = function() end,
  })
})

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
