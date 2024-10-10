-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

local highlights = require "configs.highlights"

M.base46 = {
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
}

 M.ui = {
   statusline = {
     theme = "default",
     separator_style = "arrow",
     order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd" },
     modules = {
       abc = function()
         return "hi"
       end,

       xyz =  "hi",
       f = "%F"
     }
   },
 }

return M
