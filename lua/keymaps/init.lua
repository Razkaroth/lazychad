-- #region imports

require("keymaps.edit")
require("keymaps.files")
require("keymaps.tmux")

-- Neovim-only: plugins (obsidian, nvchad) are not loaded under vscode-neovim
if not vim.g.vscode then
  require("keymaps.ui")
  require("keymaps.obsidian")
  -- require("keymaps.codecompanion")
end
--#endregion
--#region Keymaps
local map = vim.keymap.map
--#endregion
