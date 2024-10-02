local map = vim.keymap.set
-- tmux navigation
map("n", "<C-h>", ":TmuxNavigateLeft<CR>", { desc = "General - Navigate left" })
map("n", "<C-l>", ":TmuxNavigateRight<CR>", { desc = "General - Navigate right" })
map("n", "<C-j>", ":TmuxNavigateDown<CR>", { desc = "General - Navigate down" })
map("n", "<C-k>", ":TmuxNavigateUp<CR>", { desc = "General - Navigate up" })
