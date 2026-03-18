local os_utils = require("custom_tools.get_os")
local current_os = os_utils.get_current_os()

vim.pack.add({
	{ src = "https://github.com/oskarnurm/koda.nvim" }, -- light theme
	{ src = "https://github.com/metalelf0/black-metal-theme-neovim" }, -- dark theme
	{ src = "https://github.com/windwp/nvim-autopairs" }, -- autopairs
	{ src = "https://github.com/stevearc/conform.nvim" }, -- formatter
	{ src = "https://github.com/lewis6991/gitsigns.nvim" }, -- git integration for buffers
	{ src = "https://github.com/onsails/lspkind.nvim" }, -- pictograms
	{ src = "https://github.com/L3MON4D3/LuaSnip" }, -- snippets
	{ src = "https://github.com/nvim-mini/mini.icons" }, -- icons
	{ src = "https://github.com/stevearc/oil.nvim" }, -- file explorer
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- dependency
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, -- inline md render
	{ src = "https://github.com/SCJangra/table-nvim" }, -- md table editting
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" }, -- NOT WORKING
	{ src = "https://github.com/nvim-telescope/telescope.nvim" }, -- important
	{ src = "https://github.com/folke/todo-comments.nvim" }, -- highlight todo comments
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" }, -- important
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" }, -- important
	{ src = "https://github.com/lervag/vimtex" }, -- latex
	-- { src = "https://github.com/folke/which-key.nvim" }, -- Not working for me on nvim unstable
})

-- No config
require("mini.icons").setup()
require("oil").setup()
require("todo-comments").setup()

-- Config
require("telescope").setup()
-- require("telescope").load_extension("fzf") -- NOT WORKING
-- require("telescope").load_extension("dap") -- NOT WORKING

require("nvim-autopairs").setup({
	event = "InsertEnter",
	config = true,
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		css = { "prettier" },
		c3 = { "c3fmt" },
		html = { "prettier" },
		javascript = { "prettier" },
		markdown = { "prettier" },
		lua = { "stylua" },
		-- tex = { "latexindent" }, -- Using vimtex
	},
	formatters = {
		c3fmt = {
			command = "c3fmt",
			args = { "--stdin", "--stdout" },
			stdin = true,
		},
	},
})

require("gitsigns").setup({ signcolumn = false })

require("nvim-treesitter").install({
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"html",
	"css",
	"javascript",
	"json",
	"php",
	"http",
	"python",
	"c3",
	"rust",
	"gitignore",
	"yaml",
	"xml",
})
vim.treesitter.language.register("c3", "c3")
require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
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
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "<c-v>",
		},
		include_surrounding_whitespace = true,
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

require("table-nvim").setup({
	ft = "markdown, norg",
})

require("render-markdown").setup({
	enabled = true,
	completions = {
		lsp = {
			enabled = true,
		},
	},
	code = {
		style = "language",
	},
})

require("lspkind").setup({
	mode = "symbol_text",
	preset = "codicons",
})

require("luasnip").setup()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

-- VIMTEX
vim.g.vimtex_view_general_viewer = current_os == "windows" and "sioyek" or "sioyek" -- change if needed
vim.g.vimtex_compiler_latexmk = {
	out_dir = "build",
}
vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- conflicts with LSP mapping
