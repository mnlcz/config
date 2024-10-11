local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        tex = { "latexindent" },
    },
}

return {
    "stevearc/conform.nvim",
    opts = options,
}
