local servers = {
  -- Important
  -- "omnisharp",
  "lua_ls", "texlab", "marksman", "zls", "clangd",
  -- Extra servers
  "jdtls", "html", "cssls", "perlnavigator", "solargraph", "pylsp", "ts_ls",
}

----------------------------- Overrides -----------------------------
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LUAJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    }
  }
})

----------------------------- Manual -----------------------------
-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start {
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    }
  end
})

----------------------------- Setup -----------------------------
return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "mason.nvim" },
  config = function()
    local masonlsp = require("mason-lspconfig")

    masonlsp.setup({
      ensure_installed = servers,
    })
  end
}
