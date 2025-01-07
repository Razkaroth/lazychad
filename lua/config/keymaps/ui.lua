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
  })
end, { desc = "Terminals - Neofetch" })
