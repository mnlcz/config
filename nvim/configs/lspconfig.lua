local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "intelephense",
  "kotlin_language_server",
  "marksman",
  "texlab",
  "pylsp",
  "csharp_ls",
  "rust_analyzer",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

--
-- lspconfig.pyright.setup { blabla}
lspconfig.powershell_es.setup {
  bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services/",
}
