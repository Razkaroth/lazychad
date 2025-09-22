local map = vim.keymap.set
local opts = { noremap = true, silent = false }

local directories = {
  whisper = "VoidWhispers",
  record = "ArcanumRecords",
  chronicle = "Chronicles",
  etching = "CortexEtchings",
}
-- zk configuration

-- Create new notes by type
map("n", "<leader>znw", "<Cmd>ZkNew { group = 'nvimWhisper', title = vim.fn.input('Whisper Title: ') }<CR>", opts)
map("n", "<leader>znr", "<Cmd>ZkNew { group = 'nvimRecord', title = vim.fn.input('Record Title: ') }<CR>", opts)
map("n", "<leader>znc", "<Cmd>ZkNew { group = 'nvimChronicle' }<CR>", opts)
map("n", "<leader>zne", "<Cmd>ZkNew { group = 'nvimEtching', title = vim.fn.input('Etching Title: ') }<CR>", opts)

-- Open notes.
map("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)

-- Open notes associated with the selected tags.
map("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)

-- Reindex notes
map("n", "<leader>zi", "<Cmd>ZkIndex<CR>", opts)

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

-- Extract wikilink text from current cursor position
local function extract_wikilink_text()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".") - 1 -- Convert to 0-based indexing

  -- Find all wikilink patterns in the line
  local start_idx = 1
  while true do
    local link_start, link_end = line:find("%[%[[^%]]*%]%]", start_idx)
    if not link_start then
      break
    end

    -- Check if cursor is within this link (including the brackets)
    if col >= link_start - 1 and col <= link_end - 1 then
      -- Extract text between [[ and ]]
      local text = line:sub(link_start + 2, link_end - 2)
      return text:match("^%s*(.-)%s*$") -- Trim whitespace
    end

    start_idx = link_end + 1
  end

  -- Fallback to word under cursor if not in a wikilink
  return vim.fn.expand("<cword>")
end

-- Parse frontmatter to extract id
local function parse_frontmatter(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end

  local content = file:read("*all")
  file:close()

  -- Match YAML frontmatter
  local frontmatter = content:match("^%-%-%-\n(.-)%-%-%-")
  if not frontmatter then
    return nil
  end

  -- Extract id from frontmatter
  local id = frontmatter:match("id:%s*([^\n\r]+)")
  return id and id:match("^%s*(.-)%s*$") -- Trim whitespace
end

-- Update wikilink with id
local function update_wikilink_with_id(original_buf, original_pos, link_text, note_id)
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
      -- Replace the wikilink with id|alias format
      local new_link = string.format("[[%s|%s]]", note_id, link_text)
      local new_line = line:sub(1, link_start - 1) .. new_link .. line:sub(link_end + 1)
      vim.api.nvim_set_current_line(new_line)
      return
    end

    start_idx = link_end + 1
  end
end

-- Smart link navigation: follow definition or create new note
local function smart_link_goto()
  -- Try LSP definition first
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end

  -- Store original buffer and cursor position
  local original_buf = vim.api.nvim_get_current_buf()
  local original_pos = vim.api.nvim_win_get_cursor(0)
  original_pos = { row = original_pos[1] - 1, col = original_pos[2] } -- Convert to 0-based

  -- Request definition from LSP
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) then
      -- No definition found, create new note
      local link_text = extract_wikilink_text()

      -- Ask user which type of note to create
      vim.ui.select(
        { "Whisper", "Record", "Etching" },
        { prompt = "Select note type for >" .. link_text .. "<:" },
        function(choice)
          if choice then
            -- Use the link text as title
            local command = string.format("ZkNew { group = 'nvim%s', title = '%s' }", choice, link_text)
            vim.cmd(command)

            -- Wait for the new buffer to load and then extract the id
            vim.defer_fn(function()
              local new_buf = vim.api.nvim_get_current_buf()
              local new_buf_path = vim.api.nvim_buf_get_name(new_buf)
              if new_buf_path and new_buf_path ~= "" then
                local note_id = parse_frontmatter(new_buf_path)
                if note_id then
                  update_wikilink_with_id(original_buf, original_pos, link_text, note_id)
                  -- Return focus to the newly created file
                  vim.api.nvim_set_current_buf(new_buf)
                else
                  vim.notify("Could not extract note ID from frontmatter", vim.log.levels.WARN)
                end
              else
                vim.notify("Could not get new note file path", vim.log.levels.WARN)
              end
            end, 500) -- Wait 500ms for file to be written
          end
        end
      )
    else
      -- Definition found, go to it
      vim.lsp.util.show_document(result[1], "utf-8", { focus = true })
    end
  end)
end

map("n", "<leader>zd", smart_link_goto, opts)
