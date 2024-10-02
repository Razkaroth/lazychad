local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<cmd>wa<cr>", { desc = "General - Save all buffers" })

map({ "n", "v" }, "<leader>e", "<cmd>Neotree focus<cr>", { desc = "General - File Explorer" })
map({ "n", "v" }, "<leader>n", "<cmd>Neotree close<cr>", { desc = "General - File Explorer" })

map({ "n", "v" }, "<leader>G", "<cmd>LazyGit<cr>", { desc = "General - Git Alchemy" })

--#region File Navigation

-- Toggle previous & next buffers stored within Harpoon list
local harpoon = require("harpoon")
vim.keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end, { desc = "Harpoon - Previous & Next" })
vim.keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end, { desc = "Harpoon - Previous & Next" })

--#endregion
