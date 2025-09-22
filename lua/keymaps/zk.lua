local map = vim.keymap.set
local opts = { noremap = true, silent = false }

-- zk configuration

-- Create a new note after asking for its title.
map("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)

-- Open notes.
map("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)

-- Open notes associated with the selected tags.
map("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)

-- Open a Backlink picker.
map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)

-- Open a Link picker.
map("n", "<leader>zL", "<Cmd>ZkLinks<CR>", opts)

-- inser a link inplace
map("n", "<leader>zl", "<Cmd>ZkInsertLink { sort = { 'modified' } }<CR>", opts)

-- insert a link around the current selection
map("v", "<leader>zl", ":'<,'>ZkInsertLinkAtSelection<CR>", opts)

-- Search for the notes matching a given query.
map("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", opts)

-- Search for the notes matching the current visual selection.
map("v", "<leader>zf", ":'<,'>ZkMatch<CR>", opts)
