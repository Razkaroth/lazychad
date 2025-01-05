-- Required dependencies
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themery = require("themery")

local function themery_picker(opts)
  opts = opts or {}
  

  -- Get the current buffer number, content, and filetype
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype") -- Get current buffer filetype

  local themes = themery.getAvailableThemes() -- Get available themes
  local theme_names = {}
  local current_theme_index = 1 -- Default to the first theme if not found

  -- Extract theme names for display and find the index of the current theme
  for index, theme in ipairs(themes) do
    table.insert(theme_names, theme.name)
    if theme.name == (themery.getCurrentTheme() or {}).name then
      current_theme_index = index
    end
  end

  pickers
    .new(opts, {
      prompt_title = "Select a Theme",
      finder = finders.new_table({
        results = theme_names,
      }),
      sorter = sorters.get_generic_fuzzy_sorter(),
      default_selection_index = current_theme_index, -- Set the initial selection
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          themery.setThemeByName(selection[1], true) -- Apply the selected theme persistently
          print("Theme set to: " .. selection[1])
        end)

        -- Add a mapping for closing with ESC or Ctrl-c to restore the original theme
        map("i", "<ESC>", function()
          actions.close(prompt_bufnr)
          if current_theme_index then
            themery.setThemeByName(theme_names[current_theme_index], true) -- Revert to the original theme
            print("Theme reverted to: " .. theme_names[current_theme_index])
          end
        end)

        map("i", "<C-c>", function()
          actions.close(prompt_bufnr)
          if current_theme_index then
            themery.setThemeByName(theme_names[current_theme_index], true) -- Revert to the original theme
            print("Theme reverted to: " .. theme_names[current_theme_index])
          end
        end)

        return true
      end,
      previewer = previewers.new_buffer_previewer({
        define_preview = function(self, entry, status)
          local theme_name = entry.value
          themery.setThemeByName(theme_name, false) -- Temporarily apply the theme

          -- Copy content from the current buffer to the preview buffer
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

          -- Set the filetype of the preview buffer to match the source buffer for syntax highlighting
          vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", filetype)

          -- Force a redraw to update the preview window
          vim.cmd("redraw!")
        end,
      }),
    })
    :find()
end

-- Create a command to open the colorscheme picker
vim.api.nvim_create_user_command("PickThemery", themery_picker, {})
