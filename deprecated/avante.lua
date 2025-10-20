  return {
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
      providers = {
        copilot = {
          model = "claude-haiku-4.5",
        },
      },
      selection = {
        hint_display = "none",
      },
      behaviour = {
        auto_set_keymaps = false,
      },

      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        local hub_prompt = hub
            and "IMPORTANT: you should prioritize the neovim MCP toolset as those are more advanced tools. Fallback to your own only in case of failure \n" .. hub:get_active_servers_prompt()
          or ""
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
        "ls",
        "write_to_file",
        "replace_in_file",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "move_path",
        "copy_path",
        "delete_path",
        "bash", -- Built-in terminal access
        "view",
        "str_replace",
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
    keys = function()
      return {
        { "<leader>aa", "", desc = "Avante" },
        { "<leader>aaa", "<cmd>AvanteAsk<CR>", desc = "Ask Avante" },
        { "<leader>aac", "<cmd>AvanteChat<CR>", desc = "Chat with Avante" },
        { "<leader>aae", "<cmd>AvanteEdit<CR>", desc = "Edit Avante" },
        { "<leader>aaf", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
        { "<leader>aah", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
        { "<leader>aam", "<cmd>AvanteModels<CR>", desc = "Select Avante Model" },
        { "<leader>aan", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat" },
        { "<leader>aap", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
        { "<leader>aar", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
        { "<leader>aas", "<cmd>AvanteStop<CR>", desc = "Stop Avante" },
        { "<leader>aat", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
      }
    end,
  },
