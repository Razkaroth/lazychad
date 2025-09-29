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

M.new_note_from_template_with_title = function(title)
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
        local note = Note.create({ title = title, template = template_name, should_write = true })
        note:open({ sync = false })
        picker:close()
      end,
    })
  end)
end

-- Keymaps

-- Create new note from template
vim.keymap.set("n", "<leader>on", function()
  local link = api:cursor_link()
  if link then
    -- Clean the link text by removing [ and ] brackets
    local clean_link = string.gsub(link, "%[%[?(.-)%]?%]", "%1")
    M.new_note_from_template_with_title(clean_link)
  else
    -- Prompt for title if no link under cursor
    vim.ui.input({ prompt = "Note title: " }, function(title)
      if title then
        M.new_note_from_template_with_title(title)
      end
    end)
  end
end, { desc = "New note from template" })

setn("b", "Obsidian backlinks", { desc = "Show backlinks" })
