return {
  {
    "yetone/avante.nvim",
    dependencies = {
      {
        "ravitemer/mcphub.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        build = "bun i -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
        opts = {
          extensions = {
            avante = {
              make_slash_commands = true, -- make /slash commands from MCP server prompts
            },
          },
        },
      },
    },
    event = "VeryLazy",
    opts = {
      provider = "copilot",
      selection = {
        hint_display = "none",
      },

      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        local hub_prompt = hub and hub:get_active_servers_prompt() or ""
        return hub_prompt
      end,
      -- Using function prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      -- We prefer Mcp neovim server ones.
      disabled_tools = {
        "list_files", -- Built-in file operations
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash", -- Built-in terminal access
      },
    },
    cmd = {
      "AvanteAsk",
      "AvanteBuild",
      "AvanteChat",
      "AvanteClear",
      "AvanteEdit",
      "AvanteFocus",
      "AvanteHistory",
      "AvanteModels",
      "AvanteRefresh",
      "AvanteShowRepoMap",
      "AvanteStop",
      "AvanteSwitchProvider",
      "AvanteToggle",
    },
    keys = false,
    --   function()
    --   return {
    --     { "<leader>aaa", "<cmd>AvanteAsk<CR>", desc = "Ask Avante" },
    --     { "<leader>aac", "<cmd>AvanteChat<CR>", desc = "Chat with Avante" },
    --     { "<leader>aae", "<cmd>AvanteEdit<CR>", desc = "Edit Avante" },
    --     { "<leader>aaf", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
    --     { "<leader>aah", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
    --     { "<leader>aam", "<cmd>AvanteModels<CR>", desc = "Select Avante Model" },
    --     { "<leader>aan", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat" },
    --     { "<leader>aap", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
    --     { "<leader>aar", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
    --     { "<leader>aas", "<cmd>AvanteStop<CR>", desc = "Stop Avante" },
    --     { "<leader>aat", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
    --   }
    -- end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          clear_suggestion = "<C-]>",
          accept_word = "<C-Tab>",
          accept_suggestion = "<Tab>",
        },
        ignore_filetypes = {}, -- { cpp = true }, -- or { "cpp", }
        log_level = "info", -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
        condition = function()
          return false
        end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
      })
    end,
  },
}
