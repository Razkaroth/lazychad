return {
  {
    "saghen/blink.cmp",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    init = function()
      vim.api.nvim_set_hl(0, "BlinkCmpKind99", { link = "Special" })
    end,
    opts = {
      -- 7. Appearance settings for better icon spacing
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "99" },
        per_filetype = {
          codecompanion = { "codecompanion" },
          lua = { "lsp", "path", "snippets", "buffer", "lazydev" },
        },
        providers = {
          -- 7. LazyDev provider for Lua/Neovim development
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          ["99"] = {
            name = "99",
            module = "blink.compat.source",
            async = true,
          },
        },
      },

      completion = {
        -- 1. Auto-brackets support
        accept = {
          auto_brackets = {
            enabled = true,
          },
          create_undo_point = true,
          dot_repeat = true,
        },

        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },

        -- 2. Documentation window
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = true,
        },

        ghost_text = {
          enabled = true,
        },
        menu = {
          border = "rounded",
          draw = {
            gap = 1,
            -- 4. Treesitter syntax highlighting in completion menu
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", "label", gap = 1 },
              { "kind" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon

                  if ctx.source_name == "99" then
                    icon = "⦿"
                  elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    local lspkind_ok, lspkind = pcall(require, "lspkind")
                    if lspkind_ok and lspkind.symbolic then
                      icon = lspkind.symbolic(ctx.kind, { mode = "symbol" }) or icon
                    end
                  end

                  return "[" .. icon .. "] " .. ctx.icon_gap
                end,

                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if ctx.source_name == "99" then
                    hl = "BlinkCmpKind99"
                  elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
              label = {
                text = function(item)
                  return item.label
                end,
                highlight = "CmpItemAbbr",
              },
              kind = {
                text = function(ctx)
                  return ctx.kind
                end,
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },

      -- 3. Signature help (experimental)
      signature = {
        enabled = true,
      },

      -- 5. Cmdline completion
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },

      -- 6. Keymaps
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
  },
  -- nvim web-devicons
  { "nvim-tree/nvim-web-devicons", lazy = false },
  --lspkind
  {
    "onsails/lspkind-nvim",
    lazy = false,
    config = function()
      require("lspkind").init()
    end,
  },
}
