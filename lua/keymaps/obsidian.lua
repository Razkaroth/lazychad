local set = vim.keymap.set
local api = require("obsidian.api")
local util = require("obsidian.util")
local search = require("obsidian.search")
local log = require("obsidian.log")
local Note = require("obsidian.note")

local function setn(key, cmd, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set("n", "<leader>o" .. key, "<cmd>" .. cmd .. "<cr>", opts)
end

local function has_markdown_folding()
  if vim.wo.foldmethod == "expr" and vim.wo.foldexpr == "v:lua.vim.treesitter.foldexpr()" then
    return true
  elseif vim.g.markdown_folding == 1 then
    return true
  elseif vim.wo.foldmethod == "expr" and vim.wo.foldexpr == "MarkdownFold()" then
    return true
  end
  return false
end

local M = {}

-- Extract filename without extension from file path
local function get_filename_without_extension(file_path)
  local filename = file_path:match("([^/\\]+)$") -- Get filename from path
  if filename then
    return filename:match("(.+)%..+$") or filename -- Remove extension
  end
  return nil
end

-- Update wikilink with filename
local function update_wikilink_with_filename(original_buf, original_pos, link_text, filename)
  -- Switch back to original buffer
  vim.api.nvim_set_current_buf(original_buf)
  vim.api.nvim_win_set_cursor(0, { original_pos.row + 1, original_pos.col })

  local line = vim.api.nvim_get_current_line()
  local col = original_pos.col

  -- Find the wikilink at the cursor position
  local start_idx = 1
  while true do
    local link_start, link_end = line:find("%[%[[^%]]*%]%]", start_idx)
    if not link_start then
      break
    end

    -- Check if cursor is within this link
    if col >= link_start - 1 and col <= link_end - 1 then
      -- Replace the wikilink with filename|alias format
      local new_link = string.format("[[%s|%s]]", filename, link_text)
      local new_line = line:sub(1, link_start - 1) .. new_link .. line:sub(link_end + 1)
      vim.api.nvim_set_current_line(new_line)
      
      -- Save the buffer with the updated link
      vim.cmd("write")
      return
    end

    start_idx = link_end + 1
  end
end

M.new_note_from_template_with_title = function(title, original_buf, original_pos)
  local templates_dir = api.templates_dir()
  if not templates_dir then
    return log.err("Templates folder is not defined or does not exist")
  end

  if not title or title == "" then
    log.warn("Title cannot be empty")
    return
  end

  -- Convert obsidian.Path to string using the filename field
  local templates_path = templates_dir.filename

  -- Use vim.schedule to defer the picker call and avoid fast event context error
  vim.schedule(function()
    Snacks.picker.files({
      cwd = templates_path,
      confirm = function(picker, item)
        if not item or not item.text then
          log.warn("Aborted")
          return
        end

        local template_name = item.text
        ---@type obsidian.Note
        local note = Note.create({ id = title, template = template_name, should_write = true })
        note:open({ sync = false })
        picker:close()

        -- Update backlink if we have original position info
        if original_buf and original_pos then
          vim.defer_fn(function()
            local new_buf = vim.api.nvim_get_current_buf()
            local new_buf_path = vim.api.nvim_buf_get_name(new_buf)
            if new_buf_path and new_buf_path ~= "" then
              local filename = get_filename_without_extension(new_buf_path)
              if filename then
                update_wikilink_with_filename(original_buf, original_pos, title, filename)
                -- Return focus to the newly created file
                vim.api.nvim_set_current_buf(new_buf)
              else
                log.warn("Could not extract filename from path")
              end
            else
              log.warn("Could not get new note file path")
            end
          end, 500) -- Wait 500ms for file to be written
        end
      end,
    })
  end)
end

-- Keymaps

-- Create new note from template
vim.keymap.set("n", "<leader>on", function()
  local link = api:cursor_link()
  if link then
    -- Store original buffer and cursor position for backlink update
    local original_buf = vim.api.nvim_get_current_buf()
    local original_pos = vim.api.nvim_win_get_cursor(0)
    original_pos = { row = original_pos[1] - 1, col = original_pos[2] } -- Convert to 0-based

    -- Clean the link text by removing [ and ] brackets
    local clean_link = string.gsub(link, "%[%[?(.-)%]?%]", "%1")
    M.new_note_from_template_with_title(clean_link, original_buf, original_pos)
  else
    -- Prompt for title if no link under cursor (no backlink update needed)
    vim.ui.input({ prompt = "Note title: " }, function(title)
      if title then
        M.new_note_from_template_with_title(title)
      end
    end)
  end
end, { desc = "New note from template" })

setn("b", "Obsidian backlinks", { desc = "Show backlinks" })
