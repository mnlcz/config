return {
  "hrsh7th/nvim-cmp",

  dependencies = {
    -- Sources
    "hrsh7th/cmp-buffer",       -- Current buffer completions
    "hrsh7th/cmp-nvim-lsp",     -- LSP powered completions
    "hrsh7th/cmp-nvim-lua",     -- Nvim Lua completions
    "hrsh7th/cmp-path",         -- Path completions
    "saadparwaiz1/cmp_luasnip", -- Use Luasnip as snippets engine
    -- Extras
    "onsails/lspkind.nvim"      -- LSP styling
  },

  config = function()
    local cmp = require("cmp")
    local lspkind = require('lspkind')
    cmp.setup {
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),

      -- Order by priority
      sources = cmp.config.sources({
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer",  keyword_length = 5 },
      }),

      -- Snippets engine
      snippet = {
        expand = function(args)
          require 'luasnip'.lsp_expand(args.body)
        end
      },

      -- LSP cmp styling with lspkind
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text', -- show only symbol annotations
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          -- before = function(entry, vim_item)
          --   return vim_item
          -- end
        })
      }
    }
  end
}
