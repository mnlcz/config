local load = {
  ["core.defaults"] = {},  -- Loads default behaviour
  ["core.concealer"] = {}, -- Adds pretty icons to your documents
  ["core.dirman"] = {      -- Manage Neorg workspaces
    config = {
      workspaces = {
        -- notes = "~/Repos/Neorg/",
        notes = "F:/Dev/Repos/Neorg/",
      },
      default_workspace = "notes",
    },
  },
  ["core.summary"] = {
    config = {
      strategy = "default",
    },
  },
  ["core.integrations.telescope"] = {},
}

return {
  "nvim-neorg/neorg",
  lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  ft = "norg",
  opts = {
    load = load,
  },
  dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
}
