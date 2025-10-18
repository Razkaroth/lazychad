local map = vim.keymap.set

-- Keymap to toggle undotree
map("n", "<leader>U", ":UndotreeToggle<CR>", { noremap = true, silent = true })

-- Toggle Supermaven

map("n", "<leader>ax", ":SupermavenToggle<CR>", { noremap = true, silent = true, desc = "Toggle Supermaven" })
