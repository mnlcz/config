local os_utils = require("custom_tools.get_os")
local current_os = os_utils.get_current_os()
local neorg_dir = current_os == "windows" and "F:/Dev/Repos/Neorg/" or "~/Repos/Neorg/"

local load = {
  ["core.defaults"] = {},  -- Loads default behaviour
  ["core.concealer"] = {}, -- Adds pretty icons to your documents
  ["core.dirman"] = {      -- Manage Neorg workspaces
    config = {
      workspaces = {
        notes = neorg_dir,
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
