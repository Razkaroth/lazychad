local set = vim.keymap.set
local obsidian = require("obsidian")
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
  local picker = obsidian.picker
  if not picker then
    log.err("No picker configured")
    return
  end

  local templates_dir = api.templates_dir()
  if not templates_dir then
    return log.err("Templates folder is not defined or does not exist")
  end

  if not title or title == "" then
    log.warn("Title cannot be empty")
    return
  end

  picker:find_files({
    prompt_title = "Templates",
    dir = templates_dir,
    no_default_mappings = true,
    callback = function(template_name)
      if not template_name or template_name == "" then
        log.warn("Aborted")
        return
      end

      ---@type obsidian.Note
      local note = Note.create({ title = title, template = template_name, should_write = true })
      note:open({ sync = false })
    end,
  })
end

-- If cursor is on a link, follow the link
-- If cursor is on a tag, show all notes with that tag in a picker
-- If cursor is on a checkbox, toggle the checkbox
-- If cursor is on a heading, cycle the fold of that heading
M.smarter_action = function()
  local link = api:cursor_link()
  if link then
    search.resolve_link_async(link, function(result)
      if result.location == nil then
        vim.cmd("Obsidian follow_link")
      else
        M.new_note_from_template_with_title(link)
        return
      end
    end, { pick = false })
  elseif api:cursor_tag() then
    vim.cmd("Obsidian tags")
  elseif api:cursor_heading() and has_markdown_folding() then
    -- Native nvim folds
    vim.cmd("normal! zc")
  elseif util.is_checkbox(vim.api.nvim_get_current_line()) or Obsidian.opts.checkbox.create_new then
    vim.cmd("Obsidian toggle_checkbox")
  else
    vim.cmd("normal! <CR>")
  end
end

-- Smarter action

vim.api.nvim_create_autocmd("User", {
  pattern = "ObsidianNoteEnter",
  callback = function(ev)
    vim.keymap.del("n", "<CR>", { buffer = ev.buf })
    set("n", "<CR>", M.smarter_action, { buffer = ev.buf })
  end,
})

-- Other keymaps

setn("b", "Obsidian backlinks", { desc = "Show backlinks" })
