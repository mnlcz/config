-- local os_utils = require("custom_tools.get_os")
-- local current_os = os_utils.get_current_os()

vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/stevearc/conform.nvim" },
  {
    src = "https://github.com/mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      vim.api.nvim_set_hl(0, "DapStoppedHl", { fg = "#98BB6C", bg = "#2A2A2A", bold = true })
      vim.api.nvim_set_hl(0, "DapStoppedLineHl", { bg = "#204028", bold = true })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStoppedHl', linehl = 'DapStoppedLineHl', numhl = '' })
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- Commented to prevent DAP UI from closing when unit tests finish
        -- require('dapui').close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        -- Commented to prevent DAP UI from closing when unit tests finish
        -- require('dapui').close()
      end
      dap.configurations.java = {
        {
          name = "Debug Launch (2GB)",
          type = 'java',
          request = 'launch',
          vmArgs = "" ..
              "-Xmx2g "
        },
        {
          name = "Debug Attach (8000)",
          type = 'java',
          request = 'attach',
          hostName = "127.0.0.1",
          port = 8000,
        },
        {
          name = "Debug Attach (5005)",
          type = 'java',
          request = 'attach',
          hostName = "127.0.0.1",
          port = 5005,
        },
        {
          name = "My Custom Java Run Configuration",
          type = "java",
          request = "launch",
          -- You need to extend the classPath to list your dependencies.
          -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
          -- classPaths = {},

          -- If using multi-module projects, remove otherwise.
          -- projectName = "yourProjectName",

          -- javaExec = "java",
          mainClass = "replace.with.your.fully.qualified.MainClass",

          -- If using the JDK9+ module system, this needs to be extended
          -- `nvim-jdtls` would automatically populate this property
          -- modulePaths = {},
          vmArgs = "" ..
              "-Xmx2g "
        },
      }
    end
  },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/mfussenegger/nvim-jdtls" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/onsails/lspkind.nvim" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/SCJangra/table-nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-dap.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/xiyaowong/transparent.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  {
    src = "https://github.com/lervag/vimtex",
    -- Configuring it here works? Idk...
    ft = "plaintex",
    config = function()
      -- vim.g.vimtex_view_general_viewer = current_os == "windows" and "sioyek" or "zathura"
      vim.g.vimtex_view_general_viewer = "sioyek"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
      }
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- conflicts with LSP mapping
    end
  },
  -- { src = "https://github.com/folke/which-key.nvim" }, -- Not working for me on nvim unstable
  { src = "https://github.com/bettervim/yugen.nvim" },
})

-- No config
require("mini.icons").setup()
require("oil").setup()
require("telescope").setup()
-- require("telescope").load_extension("dap")
require("todo-comments").setup()

-- Config
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
    tex = { "latexindent" },
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

require("lspkind").setup({
  mode = "symbol_text",
  preset = "codicons"

})

require("nvim-dap-virtual-text").setup({
  commented = true,
  ---@diagnostic disable-next-line: unused-local
  display_callback = function(variable, buf, stackframe, node, options)
    if options.virt_text_pos == 'inline' then
      return ' = ' .. variable.value
    else
      return variable.name .. ' = ' .. variable.value
    end
  end,
})

require("dapui").setup({
  controls = {
    element = "repl",
    enabled = false,
    icons = {
      disconnect = "",
      pause = "",
      play = "",
      run_last = "",
      step_back = "",
      step_into = "",
      step_out = "",
      step_over = "",
      terminate = ""
    }
  },
  element_mappings = {},
  expand_lines = true,
  floating = {
    border = "single",
    mappings = {
      close = { "q", "<Esc>" }
    }
  },
  force_buffers = true,
  icons = {
    collapsed = "",
    current_frame = "",
    expanded = ""
  },
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.50
        },
        {
          id = "stacks",
          size = 0.30
        },
        {
          id = "watches",
          size = 0.10
        },
        {
          id = "breakpoints",
          size = 0.10
        }
      },
      size = 40,
      position = "left", -- Can be "left" or "right"
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom", -- Can be "bottom" or "top"
    }
  },
  mappings = {
    edit = "e",
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    repl = "r",
    toggle = "t"
  },
  render = {
    indent = 1,
    max_value_lines = 100
  }
})

require("luasnip").setup()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
