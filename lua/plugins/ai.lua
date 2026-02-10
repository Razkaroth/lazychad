local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  {
    "ThePrimeagen/99",
    config = function()
      local _99 = require("99")

      -- For logging that is to a file if you wish to trace through requests
      -- for reporting bugs, i would not rely on this, but instead the provided
      -- logging mechanisms within 99.  This is for more debugging purposes
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)
      _99.setup({
        model = "openai/gpt-5.1-codex-mini",
        -- provider = _99.ClaudeCodeProvider,  -- default: OpenCodeProvider
        logger = {
          level = _99.ERROR,
          path = "/tmp/" .. basename .. ".99.debug",
          print_on_error = true,
        },

        --- Completions: #rules and @files in the prompt buffer
        completion = {
          -- I am going to disable these until i understand the
          -- problem better.  Inside of cursor rules there is also
          -- application rules, which means i need to apply these
          -- differently
          -- cursor_rules = "<custom path to cursor rules>"

          --- A list of folders where you have your own SKILL.md
          --- Expected format:
          --- /path/to/dir/<skill_name>/SKILL.md
          ---
          --- Example:
          --- Input Path:
          --- "scratch/custom_rules/"
          ---
          --- Output Rules:
          --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
          --- ... the other rules in that dir ...
          ---
          custom_rules = {
            "~/.agents/skills/",
          },

          --- Configure @file completion (all fields optional, sensible defaults)
          files = {
            -- enabled = true,
            -- max_file_size = 102400,     -- bytes, skip files larger than this
            -- max_files = 5000,            -- cap on total discovered files
            -- exclude = { ".env", ".env.*", "node_modules", ".git", ... },
          },

          --- What autocomplete do you use.  We currently only
          --- support cmp right now
          source = false,
        },

        --- WARNING: if you change cwd then this is likely broken
        --- ill likely fix this in a later change
        ---
        --- md_files is a list of files to look for and auto add based on the location
        --- of the originating request.  That means if you are at /foo/bar/baz.lua
        --- the system will automagically look for:
        --- /foo/bar/AGENT.md
        --- /foo/AGENT.md
        --- assuming that /foo is project root (based on cwd)
        md_files = {
          "AGENT.md",
          "AGENTS.md",
        },
      })

      -- take extra note that i have visual selection only in v mode
      -- technically whatever your last visual selection is, will be used
      -- so i have this set to visual mode so i dont screw up and use an
      -- old visual selection
      --
      -- likely ill add a mode check and assert on required visual mode
      -- so just prepare for it now
      vim.keymap.set("v", "<leader>9v", function()
        _99.visual()
      end)

      --- if you have a request you dont want to make any changes, just cancel it
      vim.keymap.set("v", "<leader>9s", function()
        _99.stop_all_requests()
      end)
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
          accept_word = "<A-A>",
          accept_suggestion = "<C-A>",
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
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = function()
      return {
        {
          "<leader>acp",
          "<cmd>CodeCompanionActions<CR>",
          desc = "Open the action palette",
          mode = { "n", "v" },
        },
        {
          "<leader>act",
          "<cmd>CodeCompanionChat Toggle<CR>",
          desc = "Toggle a chat buffer",
          mode = { "n", "v" },
        },
        {
          "<leader>aca",
          "<cmd>CodeCompanionChat Add<CR>",
          desc = "Add code to a chat buffer",
          mode = { "v" },
        },
        {
          "<leader>acf",
          "<cmd>CodeCompanion /fix<CR>",
          desc = "Fix code",
          mode = { "v" },
        },
        {
          "<leader>aci",
          ":CodeCompanion ",
          desc = "Inline chat",
          mode = { "v" },
        },
      }
    end,
    prompt_library = {
      ["Edit workflow"] = {
        strategy = "workflow",
        description = "Use a workflow to make the ai edit code",
        opts = {
          short_name = "edit",
        },
      },
    },
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
          opts = {
            ---Decorate the user message before it's sent to the LLM
            ---@param message string
            ---@param adapter CodeCompanion.Adapter
            ---@param context table
            ---@return string
            -- prompt_decorator = function(message, adapter, context)
            --   return string.format(
            --     [[
            --     <prompt>%s</prompt>]],
            --     message
            --   )
            -- end,
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
          show_settings = false,
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

      require("codecompanion").setup(opts)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
          suggestion = { enabled = false }, -- Disabled (using Sidekick NES instead)
          panel = { enabled = false },
          filetypes = {
            markdown = true,
            yaml = true,
            gitcommit = true,
            gitrebase = true,
          },
        },
      },
      {
        "ravitemer/mcphub.nvim",
        lazy = false,
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
        config = function()
          require("mcphub").setup({
            --- `mcp-hub` binary related options-------------------
            config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to MCP Servers config file (will create if not exists)
            port = 37373, -- The port `mcp-hub` server listens to
            shutdown_delay = 5 * 60 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 5 minutes)
            use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")
            mcp_request_timeout = 60000, --Max time allowed for a MCP tool or resource to execute in milliseconds, set longer for long running tasks
            global_env = {}, -- Global environment variables available to all MCP servers (can be a table or a function returning a table)
            workspace = {
              enabled = true, -- Enable project-local configuration files
              look_for = { ".mcphub/servers.json" }, -- Files to look for when detecting project boundaries (VS Code format supported)
              reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
              port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
              get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
            },

            ---Chat-plugin related options-----------------
            auto_approve = false, -- Auto approve mcp tool calls
            auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
            extensions = {
              avante = {
                make_slash_commands = true, -- make /slash commands from MCP server prompts
              },
            },

            --- Plugin specific options-------------------
            native_servers = {}, -- add your custom lua native servers here
            builtin_tools = {
              edit_file = {
                parser = {
                  track_issues = true,
                  extract_inline_content = true,
                },
                locator = {
                  fuzzy_threshold = 0.8,
                  enable_fuzzy_matching = true,
                },
                ui = {
                  go_to_origin_on_complete = true,
                  keybindings = {
                    accept = ".",
                    reject = ",",
                    next = "n",
                    prev = "p",
                    accept_all = "ga",
                    reject_all = "gr",
                  },
                },
              },
            },
            ui = {
              window = {
                width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
                height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
                align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
                relative = "editor",
                zindex = 50,
                border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
              },
              wo = { -- window-scoped options (vim.wo)
                winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
              },
            },
            json_decode = nil, -- Custom JSON parser function (e.g., require('json5').parse for JSON5 support)
            on_ready = function(hub)
              -- Called when hub is ready
            end,
            on_error = function(err)
              -- Called on errors
            end,
            log = {
              level = vim.log.levels.WARN,
              to_file = false,
              file_path = nil,
              prefix = "MCPHub",
            },
          })
        end,
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
    opts = {
      nes = {
        enabled = true,
      },
    },
    keys = function()
      return {
        -- nes is also useful in normal mode
        { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
        { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
        { "<leader>as", "", desc = "Sidekick", mode = { "n", "v" } },
        {
          "<A-,>",
          function()
            require("sidekick.cli").toggle()
          end,
          desc = "Sidekick Toggle",
          mode = { "n", "t", "i", "x" },
        },
        {
          "<leader>aa",
          function()
            require("sidekick.cli").toggle()
          end,
          desc = "Sidekick Toggle CLI",
        },
        {
          "<leader>as",
          function()
            require("sidekick.cli").select()
          end,
          -- Or to select only installed tools:
          -- require("sidekick.cli").select({ filter = { installed = true } })
          desc = "Select CLI",
        },
        {
          "<leader>ad",
          function()
            require("sidekick.cli").close()
          end,
          desc = "Detach a CLI Session",
        },
        {
          "<leader>at",
          function()
            require("sidekick.cli").send({ msg = "{this}" })
          end,
          mode = { "x", "n" },
          desc = "Send This",
        },
        {
          "<leader>af",
          function()
            require("sidekick.cli").send({ msg = "{file}" })
          end,
          desc = "Send File",
        },
        {
          "<leader>av",
          function()
            require("sidekick.cli").send({ msg = "{selection}" })
          end,
          mode = { "x" },
          desc = "Send Visual Selection",
        },
        {
          "<leader>ap",
          function()
            require("sidekick.cli").prompt()
          end,
          mode = { "n", "x" },
          desc = "Sidekick Select Prompt",
        },
      }
    end,
  },
}
