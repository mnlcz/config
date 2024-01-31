---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "dark_horizon",
  theme_toggle = { "onedark", "one_light" },

  changed_themes = {
    dark_horizon = {
      base_30 = {
        black = "#000000",
        darker_black = "#000000",
        statusline_bg = "#010101",
        one_bg3 = "#000000",
      },
      base_16 = {
        base00 = "#000000",
      },
    },
  },

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = {
    load_on_startup = true,
  },

  statusline = {
    theme = "default",
    separator_style = "default",
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
