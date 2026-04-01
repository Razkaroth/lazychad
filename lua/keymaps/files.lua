local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<cmd>wa<cr>", { desc = "General - Save all buffers" })

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

-- Do not load harpoon on vscode mode
if not vim.g.vscode then
  -- Toggle previous & next buffers stored within Harpoon list
  local harpoon = require("harpoon")
  vim.keymap.set("n", "<C-S-P>", function()
    harpoon:list():prev()
  end, { desc = "Harpoon - Previous & Next" })
  vim.keymap.set("n", "<C-S-N>", function()
    harpoon:list():next()
  end, { desc = "Harpoon - Previous & Next" })
end
--#endregion
