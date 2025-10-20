return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = function()
      return {
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
          "<cmd>CodeCompanion /fix<CR>",
          desc = "Fix code",
          mode = { "v" },
        },
        {
          "<leader>ae",
          "<cmd>CodeCompanion /explain<CR>",
          desc = "Explain code",
          mode = { "v" },
        },
        {
          "<leader>ai",
          ":CodeCompanion ",
          desc = "Inline chat",
          mode = { "v" },
        },
      }
    end,
    opts = {

      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-5-mini",
          },
          tools = {
            opts = {
              auto_submit_errors = true, -- Send any errors to the LLM automatically?
              auto_submit_success = true, -- Send any successful output to the LLM automatically?
              default_tools = {
                "mcp",
              },
            },
          },
        },
        inline = {
          adapter = {
            name = "copilot",
            model = "gpt-5-mini",
          },
        },
      },
      display = {
        chat = {
          show_settings = true,
        },
        action_palette = {
          width = 95,
          height = 10,
          provider = "default",
          opts = {
            show_default_prompt_library = true,
            title = "CodeCompanion actions",
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
      {
        "ravitemer/mcphub.nvim",
        lazy = false,
      },
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
  {
    "folke/sidekick.nvim",
    keys = function()
      return {
        -- nes is also useful in normal mode
        { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
        { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
        { "<leader>as", "", desc = "Sidekick", mode = { "n", "v" } },
        {
          "<c-.>",
          function()
            require("sidekick.cli").toggle()
          end,
          desc = "Sidekick Toggle",
          mode = { "n", "t", "i", "x" },
        },
        {
          "<leader>asa",
          function()
            require("sidekick.cli").toggle()
          end,
          desc = "Sidekick Toggle CLI",
        },
        {
          "<leader>ass",
          function()
            require("sidekick.cli").select()
          end,
          -- Or to select only installed tools:
          -- require("sidekick.cli").select({ filter = { installed = true } })
          desc = "Select CLI",
        },
        {
          "<leader>asd",
          function()
            require("sidekick.cli").close()
          end,
          desc = "Detach a CLI Session",
        },
        {
          "<leader>ast",
          function()
            require("sidekick.cli").send({ msg = "{this}" })
          end,
          mode = { "x", "n" },
          desc = "Send This",
        },
        {
          "<leader>asf",
          function()
            require("sidekick.cli").send({ msg = "{file}" })
          end,
          desc = "Send File",
        },
        {
          "<leader>asv",
          function()
            require("sidekick.cli").send({ msg = "{selection}" })
          end,
          mode = { "x" },
          desc = "Send Visual Selection",
        },
        {
          "<leader>asp",
          function()
            require("sidekick.cli").prompt()
          end,
          mode = { "n", "x" },
          desc = "Sidekick Select Prompt",
        },
      }
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    keys = {
      { "<leader>aS", "<cmd>SupermavenToggle<CR>", desc = "Toggle Supermaven" },
    },
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
