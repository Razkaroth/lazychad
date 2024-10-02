-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "flexoki",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.ui = {
  nvdash = {
    header = {
      [[
      ██████╗  █████╗ ███████╗██╗  ██╗ █████╗ ██████╗  ██████╗ ████████╗██╗  ██╗      
      ██╔══██╗██╔══██╗╚══███╔╝██║ ██╔╝██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝██║  ██║
      ██████╔╝███████║  ███╔╝ █████╔╝ ███████║██████╔╝██║   ██║   ██║   ███████║
      ██╔══██╗██╔══██║ ███╔╝  ██╔═██╗ ██╔══██║██╔══██╗██║   ██║   ██║   ██╔══██║
      ██║  ██║██║  ██║███████╗██║  ██╗██║  ██║██║  ██║╚██████╔╝   ██║   ██║  ██║
      ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝
                                'Tis but a scratch.                             
    ]],
    },
  },
  tabufline = {},
}

return M