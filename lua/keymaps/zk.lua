local map = vim.keymap.set
local opts = { noremap = true, silent = false }

-- zk configuration

-- Create new notes by type
map("n", "<leader>znw", "<Cmd>ZkNew { group = 'whisper', title = vim.fn.input('Whisper Title: ') }<CR>", opts)
map("n", "<leader>znr", "<Cmd>ZkNew { group = 'record', title = vim.fn.input('Record Title: ') }<CR>", opts)
map("n", "<leader>znc", "<Cmd>ZkNew { group = 'chronicle' }<CR>", opts)
map("n", "<leader>zne", "<Cmd>ZkNew { group = 'etching', title = vim.fn.input('Etching Title: ') }<CR>", opts)

-- Open notes.
map("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)

-- Open notes associated with the selected tags.
map("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)

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

-- Smart link navigation: follow definition or create new note
local function smart_link_goto()
  -- Try LSP definition first
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  
  if #clients == 0 then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end

  -- Request definition from LSP
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) then
      -- No definition found, create new note
      
      -- Get the word under cursor (potential link text)
      local word = vim.fn.expand("<cword>")
      local line = vim.api.nvim_get_current_line()
      local col = vim.fn.col(".")
      
      -- Try to extract wikilink text [[text]]
      local link_text = word
      local start_pos = line:find("%[%[[^%]]*", col - #word)
      if start_pos then
        local end_pos = line:find("%]%]", start_pos)
        if end_pos then
          link_text = line:sub(start_pos + 2, end_pos - 1)
        end
      end
      
      -- Ask user which type of note to create
      vim.ui.select(
        { "whisper", "record", "etching" },
        { prompt = "Select note type:" },
        function(choice)
          if choice then
            -- Use the link text as title
            vim.cmd(string.format("ZkNew { group = '%s', title = '%s' }", choice, link_text))
          end
        end
      )
    else
      -- Definition found, go to it
      vim.lsp.util.jump_to_location(result[1], "utf-8")
    end
  end)
end

map("n", "<leader>zgd", smart_link_goto, opts)
