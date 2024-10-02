local map = vim.keymap.set

map(
  "n",
  "<leader><leader>",
  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
  { desc = "Telescope - LSP Dynamic Workspace Symbols" }
)
