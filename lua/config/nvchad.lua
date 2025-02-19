return {
  "nvim-lua/plenary.nvim",
 { "nvim-tree/nvim-web-devicons", lazy = true },
 "nvchad/volt", -- optional, needed for theme switcher
  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require "nvchad"
    end
  },
  {
    "nvchad/base46",
    lazy = "false",
    build = function()
      require("base46").load_all_highlights()
    end
  }
}
