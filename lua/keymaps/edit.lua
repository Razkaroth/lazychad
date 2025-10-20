local map = vim.keymap.set

-- Keymap to toggle undotree
map("n", "<leader>U", ":UndotreeToggle<CR>", { noremap = true, silent = true })

-- Save all buffers
map({ "n", "i", "v" }, "<C-s>", "<cmd>wa<cr>", { desc = "General - Save all buffers" })

-- create a "Q" command that writes all buffers and quits
vim.api.nvim_create_user_command("Q", ":qall!", {})
