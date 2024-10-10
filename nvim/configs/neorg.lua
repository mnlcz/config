local neorg = require("neorg")

local options = {
	load = {
		["core.defaults"] = {},     -- Loads default behaviour
		["core.concealer"] = {},    -- Adds pretty icons to your documents
		["core.dirman"] = {         -- Manage Neorg workspaces
			config = {
				workspaces = {
					notes = "~/repos/Neorg/",
				},
			},
		},
	},
}

neorg.setup(options)
