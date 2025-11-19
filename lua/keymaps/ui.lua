local map = vim.keymap.set

-- themes
map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "Themes - Open theme switcher" })

-- terms
map({ "n", "v", "i", "t" }, "<A-i>", function()
  require("nvchad.term").toggle({
    pos = "float",
    id = "floatTerm",
    float_opts = {
      -- half of empty space in the screen so it's centered
      row = 0.1,
      col = 0.1,
      height = 0.8,
      width = 0.8,
    },
  })
end, { desc = "Terminals - Neofetch" })
