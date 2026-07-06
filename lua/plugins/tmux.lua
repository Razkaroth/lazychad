-- Local log variable for conditional logging
local log = false

-- Global function for manual loading
_G.setup_tmux_keymaps = function()
  local map = vim.keymap.set
  if log then
    print("Setting up tmux keymaps...")
  end

  if vim.env.HERDR_ENV == "1" then
    local function nav(wincmd, dir)
      local prev = vim.api.nvim_get_current_win()
      vim.cmd("wincmd " .. wincmd)
      if vim.api.nvim_get_current_win() ~= prev then
        return
      end

      if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
        local herdr = vim.env.HERDR_BIN_PATH
        if herdr == nil or herdr == "" then
          herdr = "herdr"
        end
        vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--current" })
      elseif vim.env.TMUX and vim.env.TMUX ~= "" then
        local tmux = { left = "Left", down = "Down", up = "Up", right = "Right" }
        pcall(vim.cmd, "TmuxNavigate" .. tmux[dir])
      end
    end

    local function herdr_map(lhs, wincmd, dir, desc)
      map("n", lhs, function()
        nav(wincmd, dir)
      end, { silent = true, noremap = true, desc = desc })
    end

    herdr_map("<C-h>", "h", "left", "General - Navigate left (vim/herdr)")
    herdr_map("<C-j>", "j", "down", "General - Navigate down (vim/herdr)")
    herdr_map("<C-k>", "k", "up", "General - Navigate up (vim/herdr)")
    herdr_map("<C-l>", "l", "right", "General - Navigate right (vim/herdr)")

    if log then
      print("✅ Herdr keymaps configured successfully!")
    end
    return true
  end

  -- Check if commands exist before mapping
  local commands_exist = pcall(function()
    vim.api.nvim_command("TmuxNavigatorProcessList")
  end)
  if not commands_exist then
    if log then
      print("❌ Tmux commands not available yet!")
    end
    return false
  end

  map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "General - Navigate left" })
  map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "General - Navigate right" })
  map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "General - Navigate down" })
  map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "General - Navigate up" })

  if log then
    print("✅ Tmux keymaps configured successfully!")
  end
  return true
end

-- Set up the manual loader keymap immediately
vim.keymap.set("n", "<leader>tt", function()
  if log then
    print("📦 Manually loading tmux navigation...")
  end
  local success = _G.setup_tmux_keymaps()
  if success then
    if log then
      print("🎉 Tmux navigation ready! Try <C-h>, <C-j>, <C-k>, <C-l>")
    end
  else
    if log then
      print("⚠️  Commands not available yet. Plugin may not be loaded.")
    end
    if log then
      print("Try restarting Neovim or check if vim-tmux-navigator is installed.")
    end
  end
end, { desc = "Load Tmux Navigator" })

return {
  {
    -- tmux integration
    "christoomey/vim-tmux-navigator",
    lazy = false, -- Back to not lazy loading
    config = function()
      -- Try to set up keymaps automatically after a delay
      vim.defer_fn(function()
        _G.setup_tmux_keymaps()
      end, 1000) -- Wait 1 second after plugin config
    end,
  },
}
