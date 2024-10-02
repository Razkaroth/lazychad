-- put this in your main init.lua file ( before lazy setup )
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46"
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- put this after lazy setup
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
