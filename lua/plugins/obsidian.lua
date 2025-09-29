function Simpler_id(title)
  -- An id compatible with zk
  -- returns <id:XXXX>-<titleslug>
  local slug = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
  local id = ""
  for _ = 1, 4 do
    -- generate a random alphanumeric id of length 4
    id = id .. string.char(math.random(97, 122))
  end
  return id .. "-" .. slug
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "codex",
        path = "~/vaults/codex-astartes/",
      },
    },

    legacy_commands = false,

    preferred_link_style = "wiki",
    open_notes_in = "current",
    templates = {
      folder = "obsidian/nvim-templates",
      substitutions = {
        yesterday = function()
          return "" .. os.date("%Y-%m-%d", os.time() - 86400)
        end,
        tomorrow = function()
          return "" .. os.date("%Y-%m-%d", os.time() + 86400)
        end,
      },

      customizations = {
        -- Own journal
        chronicle = {
          notes_subdir = "chronicles",
          note_id_func = function(_)
            return "" .. os.date("%Y/%Y-%m-%d", os.time())
          end,
        },
        -- fleeting notes
        whisper = {
          notes_subdir = "whispers",
          note_id_func = Simpler_id,
        },
        -- permanent notes
        inscription = {
          notes_subdir = "inscriptions",
          note_id_func = Simpler_id,
        },
        -- Reference/literature notes
        record = {
          notes_subdir = "archives",
          note_id_func = Simpler_id,
        },
        -- Biographical notes
        profile = {
          notes_subdir = "profiles",
          note_id_func = Simpler_id,
        },
        -- Research/study notes
        treatise = {
          notes_subdir = "treatises",
          note_id_func = Simpler_id,
        },
        -- External writings
        proclamation = {
          notes_subdir = "proclamations",
          note_id_func = Simpler_id,
        },
        operation = {
          notes_subdir = "operations",
          note_id_func = Simpler_id,
        },
      },
    },
  },
}
