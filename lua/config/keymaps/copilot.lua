local map = vim.keymap.set

-- Copilot chat

-- Show help actions with telescope
map("n", "<leader>ah", function()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.help_actions())
end, { desc = "CopilotChat - Help actions" })

-- Show prompts actions with telescope (normal mode)
map("n", "<leader>aP", function()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { desc = "CopilotChat - Prompt actions" })

-- Show prompts actions with telescope (normal mode, selection => buffer)
map("n", "<leader>ap", function()
  require("CopilotChat.integrations.telescope").pick(
    require("CopilotChat.actions").prompt_actions({ selection = require("CopilotChat.select").buffer })
  )
end, { desc = "CopilotChat - Prompt actions for buffer" })

-- Show prompts actions with telescope (visual mode)
map("x", "<leader>ap", function()
  require("CopilotChat.integrations.telescope").pick(
    require("CopilotChat.actions").prompt_actions({ selection = require("CopilotChat.select").visual })
  )
end, { desc = "CopilotChat - Prompt actions" })

-- Code related commands
map("n", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "CopilotChat - Explain code" })
map("n", "<leader>at", "<cmd>CopilotChatTests<cr>", { desc = "CopilotChat - Generate tests" })
map("n", "<leader>ar", "<cmd>CopilotChatReview<cr>", { desc = "CopilotChat - Review code" })
map("n", "<leader>aR", "<cmd>CopilotChatRefactor<cr>", { desc = "CopilotChat - Refactor code" })
map("n", "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", { desc = "CopilotChat - Better Naming" })

map("n", "<leader>ab", "<cmd>CopilotChatBuffer<cr>", { desc = "CopilotChat - Buffer selection" })
-- Chat with Copilot in visual mode
map("x", "<leader>av", ":CopilotChatVisual<cr>", { desc = "CopilotChat - Open in vertical split" })
map("x", "<leader>ax", ":CopilotChatInline<cr>", { desc = "CopilotChat - Inline chat" })

-- Custom input for CopilotChat
map("n", "<leader>ai", function()
  local input = vim.fn.input("Ask Copilot: ")
  if input ~= "" then
    vim.cmd("CopilotChat " .. input)
  end
end, { desc = "CopilotChat - Ask input" })

-- Generate commit message based on the git diff
map("n", "<leader>am", "<cmd>CopilotChatCommit<cr>", { desc = "CopilotChat - Generate commit message for all changes" })
map(
  "n",
  "<leader>aM",
  "<cmd>CopilotChatCommitStaged<cr>",
  { desc = "CopilotChat - Generate commit message for staged changes" }
)

-- Quick chat with Copilot
map("n", "<leader>aq", function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    vim.cmd("CopilotChatBuffer " .. input)
  end
end, { desc = "CopilotChat - Quick chat" })

-- Debug
map("n", "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", { desc = "CopilotChat - Debug Info" })

-- Fix the issue with diagnostic
map("n", "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", { desc = "CopilotChat - Fix Diagnostic" })

-- Clear buffer and chat history
map("n", "<leader>al", "<cmd>CopilotChatReset<cr>", { desc = "CopilotChat - Clear buffer and chat history" })

-- Toggle Copilot Chat Vsplit
map("n", "<leader>av", "<cmd>CopilotChatToggle<cr>", { desc = "CopilotChat - Toggle" })

-- Copilot Chat Models
map("n", "<leader>a?", "<cmd>CopilotChatModels<cr>", { desc = "CopilotChat - Select Models" })
