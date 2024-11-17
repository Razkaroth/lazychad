-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "yoru",

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
  cmp = {
    lspkind_text = true,
    style = "flat_light", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = true,
    },
  },

  tabufline = {},
  statusline = {
    enabled = false,
  },
}

M.term = {
  float = {
    row = 0.2,
    width = 0.5,
    height = 0.6,
  },
}

return M
