local options = {
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manage Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/repos/Neorg/",
                },
                default_workspace = "notes",
            },
        },
    },
}

return {
    "nvim-neorg/neorg",
    lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = function()
        require("neorg").setup(options)
    end,
}
