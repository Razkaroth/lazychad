local map = vim.keymap.set
-- tmux navigation
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "General - Navigate left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "General - Navigate right" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "General - Navigate down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "General - Navigate up" })
