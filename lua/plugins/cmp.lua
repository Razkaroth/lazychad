return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "nvchad/ui",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
      "f3fora/cmp-spell",
      "ray-x/cmp-treesitter",
      "kdheepak/cmp-latex-symbols",
      "jmbuhr/cmp-pandoc-references",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind-nvim",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      local lspkind = require("lspkind")
      opts.completion = {
        completeopt = "menu,menuone,noselect",
      }
      opts.sources = {
        { name = "path" },
        { name = "nvim_lsp_signature_help", max_item_count = 15 },
        { name = "nvim_lsp", max_item_count = 15 },
        { name = "luasnip", keyword_length = 3, max_item_count = 3 },
        { name = "pandoc_references" },
        { name = "buffer", keyword_length = 5, max_item_count = 3 },
        { name = "spell" },
        { name = "treesitter", keyword_length = 5, max_item_count = 3 },
        { name = "calc" },
        { name = "latex_symbols" },
        { name = "emoji", keyword_length = 3 },
      }
      -- opts.formatting = {
      --   fields = { "kind", "abbr", "menu" },
      --   format = function(entry, vim_item)
      --     local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      --     local strings = vim.split(kind.kind, "%s", { trimempty = true })
      --     kind.kind = " " .. (strings[1] or "") .. " "
      --     kind.menu = "    (" .. (strings[2] or "") .. ")"
      --
      --     return kind
      --   end,
      -- }
      opts.formatting = {
        format = lspkind.cmp_format({
          mode = "symbol",
          menu = {
            otter = "[🦦]",
            nvim_lsp = "[LSP]",
            nvim_lsp_signature_help = "[sig]",
            luasnip = "[snip]",
            buffer = "[buf]",
            path = "[path]",
            spell = "[spell]",
            pandoc_references = "[ref]",
            tags = "[tag]",
            treesitter = "[TS]",
            calc = "[calc]",
            latex_symbols = "[tex]",
            emoji = "[emoji]",
          },
        }),
      }

      opts.experimental = {
        ghost_text = false,
      }
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- cp.confirm({ select = true })
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
      })
      opts = vim.tbl_deep_extend("force", opts, require("nvchad.cmp"))
    end,
  },
}
