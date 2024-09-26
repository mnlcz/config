-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "intelephense",
  "groovyls",
  "jdtls",
  "kotlin_language_server",
  "marksman",
  "texlab",
  "perlnavigator",
  "pylsp",
  "rust_analyzer",
  "solargraph",
  "zls",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- lspconfig.powershell_es.setup {
--   bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services/",
-- }

-- lspconfig.omnisharp.setup {
--   cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
--   enable_editorconfig_support = true,
--   enable_ms_build_load_projects_on_demand = false,
--   enable_roslyn_analyzers = true,
--   organize_imports_on_format = true,
--   enable_import_completion = false,
--   sdk_include_prereleases = true,
--   analyze_open_documents_only = false,
-- }
