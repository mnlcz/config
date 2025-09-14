local needed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "html", "css", "javascript", "json",
  "php", "http", "ruby", "python", "c_sharp", "rust", "kotlin", "latex", "gitignore", "yaml", "xml", "zig", "java" }

return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = needed,
      sync_install = false,
      auto_install = true,
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
    }
  end,
}
