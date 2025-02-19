
local map = vim.keymap.set

-- Keymap to toggle undotree
map('n', '<leader>U', ':UndotreeToggle<CR>', { noremap = true, silent = true })
