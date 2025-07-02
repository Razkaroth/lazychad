# Neovim Configuration - Agent Guidelines

## Commands
- **Format Lua code**: `stylua <file_path>`
- **Check syntax**: `luacheck <file_path>`
- No test commands found in the codebase

## Code Style
- **Indentation**: 2 spaces (see `stylua.toml`)
- **Line width**: 120 columns maximum
- **Regions**: Use `--#region` and `--#endregion` for code sections
- **Function declarations**: Use local functions where possible
- **Imports**: Group imports at the top of files
- **Variable naming**: snake_case for variables and functions
- **Keymaps**: Use `vim.keymap.set` for mapping keys
- **Error handling**: Use `pcall` for protected calls

## Project Structure
- `/lua/config`: Core configuration files
- `/lua/keymaps`: Keyboard mapping definitions
- `/lua/plugins`: Plugin configurations
- Follows LazyVim convention with custom plugins

## Plugin System
- Uses Lazy.nvim for plugin management
- Plugin specs defined in separate files in `/lua/plugins`
- Custom plugin configurations should match existing conventions