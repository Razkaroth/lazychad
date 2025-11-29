# Neovim Configuration - Agent Guidelines

## Commands
- **Format**: `stylua <file_path>` or `stylua .` (formats all Lua files)
- **Lint**: `luacheck <file_path>` (if available, not required)
- **No tests**: This is a Neovim config - no test suite present

## Code Style
- **Indentation**: 2 spaces, no tabs (`stylua.toml`)
- **Line width**: 120 columns max
- **Imports**: Group `local x = require(...)` at top of file, before code
- **Regions**: Use `--#region` / `--#endregion` to mark logical sections
- **Types**: Use LuaLS annotations (`---@type`, `---@param`, `---@class`, `---@module`)
- **Functions**: Prefer `local function name()` for module-local functions
- **Naming**: snake_case for variables/functions, PascalCase for classes/modules
- **Error handling**: Use `pcall()` for protected calls to prevent crashes
- **Comments**: Stylua ignore: `-- stylua: ignore` on line before code to skip

## Project Structure
- `/lua/config/`: Core config (keymaps, options, autocmds, lazy.nvim setup)
- `/lua/keymaps/`: Keymap definitions split by category
- `/lua/plugins/`: Plugin specs (one plugin per file, auto-loaded by lazy.nvim)
- `/lua/plugins/utils/`: Utility modules for plugins
- Follows LazyVim conventions with custom overrides

## Plugin Patterns
- Return table from plugin files: `return { "author/plugin", opts = {...} }`
- Use `opts` for simple config, `config = function() ... end` for complex setup
- Keymaps: Define in `keys` table with `desc` for which-key integration