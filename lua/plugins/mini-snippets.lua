return {
  {
    "nvim-mini/mini.snippets",
    opts = function(_, opts)
      -- change ONLY what you want, keep the rest
      opts.mappings = opts.mappings or {}

      -- example: change jump_next to <Tab>
      opts.mappings.jump_next = "<C-A>"
      return opts
    end,
  },
}
