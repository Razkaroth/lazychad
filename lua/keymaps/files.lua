local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<cmd>wa<cr>", { desc = "General - Save all buffers" })

-- Neovim-only: LazyGit, Snacks picker, and Harpoon are not loaded under vscode-neovim
if not vim.g.vscode then
  map({ "n", "v" }, "<leader>G", "<cmd>LazyGit<cr>", { desc = "General - Git Alchemy" })

  pcall(vim.keymap.del, "n", "<leader><leader>")
  pcall(vim.keymap.del, "n", "<leader>/")
  pcall(vim.keymap.del, "v", "<leader>/")

  map("n", "<leader><leader>", function()
    LazyVim.pick("files", { cwd = vim.fn.getcwd() })()
  end, { desc = "Picker - Find files (pwd)" })

  map("n", "<leader>/", function()
    LazyVim.pick("live_grep", { cwd = vim.fn.getcwd() })()
  end, { desc = "Picker - Grep in files (pwd)" })

  --#region File Navigation
  local harpoon = require("harpoon")
  vim.keymap.set("n", "<C-S-P>", function()
    harpoon:list():prev()
  end, { desc = "Harpoon - Previous & Next" })
  vim.keymap.set("n", "<C-S-N>", function()
    harpoon:list():next()
  end, { desc = "Harpoon - Previous & Next" })
  --#endregion
end
