return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      {
        "<leader>ap",
        "<cmd>CodeCompanionActions<CR>",
        desc = "Open the action palette",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<CR>",
        desc = "Toggle a chat buffer",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Add<CR>",
        desc = "Add code to a chat buffer",
        mode = { "v" },
      },
      {
        "<leader>af",
        "<cmd>CodeCompanion /f<CR>",
        desc = "Fix code",
        mode = { "v" },
      },
      {
        "<leader>ai",
        ":CodeCompanion ",
        desc = "Inline chat",
        mode = { "v" },
      },
    },
    opts = {

      adapters = {
        acp = {
          gemini_cli = "gemini_cli",
        },
      },

      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-haiku-4.5",
          },
        },
        inline = {
          adapter = {
            name = "copilot",
            model = "gpt-5-mini",
          },
        },
      },

      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },

      keymaps = {
        send = {
          callback = function(chat)
            vim.cmd("stopinsert")
            chat:submit()
            chat:add_buf_message({ role = "llm", content = "" })
          end,
          index = 1,
          description = "Send",
        },
      },
    },
    config = function(_, opts)
      local spinner = require("plugins.utils.cc-spinner")
      local columnmarks = require("plugins.utils.cc-columnmarks")

      spinner:init()
      columnmarks.setup()
      require("mcphub").setup()

      require("codecompanion").setup(opts)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      "ravitemer/mcphub.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
      },
      {
        "nvim-mini/mini.diff",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
      {
        "HakonHarnes/img-clip.nvim",
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
    },
  },
}
