local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    latex = { "latexindent" },
    -- kotlin = { "ktlint" },
    tex = { "latexindent" },
    plaintex = { "latexindent" },
    markdown = { "prettier" },
    php = { "pint" },
    python = { "black" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
