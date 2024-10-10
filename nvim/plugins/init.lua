return {
	------------------ With opts in /configs ------------------
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require("configs.conform"),
	},

	{
		"NvChad/nvterm",
		opts = require("configs.nvterm"),
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"nvim-neorg/neorg",
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = "*", -- Pin Neorg to the latest stable release
		-- config = true, -- Default config
    -- check https://dotfyle.com/plugins/nvim-neorg/neorg for possible configs
    config = function()
      require("configs.neorg")
    end,
	},

	------------------ Inline configs ------------------
	-- {
	--   "nvim-treesitter/nvim-treesitter",
	--   opts = {
	--     ensure_installed = {
	--       "vim",
	--       "lua",
	--       "vimdoc",
	--
	--       -- web
	--       "html",
	--       "css",
	--       "javascript",
	--       "typescript",
	--       "tsx",
	--       "json",
	--       "php",
	--       "vue",
	--       "http",
	--
	--       -- general langs
	--       "ruby",
	--       "python",
	--       "c_sharp",
	--       "c",
	--       "rust",
	--       "kotlin",
	--
	--       -- misc
	--       "markdown",
	--       "markdown_inline",
	--       "latex",
	--       "gitignore",
	--       "yaml",
	--       "xml",
	--     },
	--   },
	-- },

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
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
		},
	},

	------------------ Added plugins ------------------
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{
		"lervag/vimtex",
		lazy = false,
		ft = "plaintex",
		config = function()
			-- Set the vimtex_viewer
			vim.g.vimtex_view_method = "zathura"
			-- vim.g.vimtex_view_general_viewer = "sioyek"
			-- Set the vimtex_compiler_latexmk configuration
			vim.g.vimtex_compiler_latexmk = {
				out_dir = "build",
			}
		end,
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow",
	},
}
