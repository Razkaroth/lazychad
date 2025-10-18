local map = vim.keymap.set

local function setn(key, cmd, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set("n", "<leader>o" .. key, "<cmd>" .. cmd .. "<cr>", opts)
end
