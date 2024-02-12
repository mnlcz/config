local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",

    -- web
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "php",
    "vue",
    "http",

    -- general langs
    "ruby",
    "python",
    "c_sharp",
    "c",
    "rust",

    -- misc
    "markdown",
    "markdown_inline",
    "latex",
    "gitignore",
    "yaml",
    "xml",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- php
    "intelephense",
    "pint",

    -- low lvl
    "clangd",
    "clang-format",
    "rust-analyzer",

    -- csharp
    "csharp-language-server",

    -- python
    "python-lsp-server",
    "pylint",
    "black",

    -- shell
    "powershell-editor-services",

    -- markdown
    "marksman",

    -- latex
    "texlab",
    "latexindent",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
