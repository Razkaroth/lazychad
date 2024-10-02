return {
  "kdheepak/lazygit.nvim",
  -- load when opening a folder with .git directory
  cmd = { "LazyGit", "LazyGitConfig" },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
