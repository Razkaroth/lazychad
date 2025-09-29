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
        },
        -- permanent notes
        inscription = {
          notes_subdir = "inscriptions",
        },
        -- Reference/literature notes
        record = {
          notes_subdir = "archives",
        },
        -- Biographical notes
        profile = {
          notes_subdir = "profiles",
        },
        -- Research/study notes
        treatise = {
          notes_subdir = "treatises",
        },
        -- External writings
        proclamation = {
          notes_subdir = "proclamations",
        },
        operation = {
          notes_subdir = "operations",
        },
      },
    },
  },
}
