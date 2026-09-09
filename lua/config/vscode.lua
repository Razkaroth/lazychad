local vscode = require("vscode")

local function action(cmd, opts)
  vscode.action(cmd, opts)
end

-- Open lazygit in the integrated terminal; fall back to SCM view
local function open_lazygit()
  action("workbench.action.terminal.toggleTerminal", {
    callback = function(err)
      if err then
        action("workbench.view.scm")
        return
      end
      vim.defer_fn(function()
        action("workbench.action.terminal.sendSequence", {
          args = { text = "lazygit\n" },
          callback = function(send_err)
            if send_err then
              action("workbench.view.scm")
            end
          end,
        })
      end, 150)
    end,
  })
end

--#region LSP and Code Actions
vim.keymap.set("n", "<leader>ca", function()
  action("editor.action.quickFix")
end, { desc = "Code Action" })

vim.keymap.set("n", "<leader>cr", function()
  action("editor.action.rename")
end, { desc = "Rename Symbol" })

vim.keymap.set("n", "<leader>cf", function()
  action("editor.action.formatDocument")
end, { desc = "Format Document" })

vim.keymap.set("n", "<leader>ci", function()
  action("editor.action.sourceAction", {
    args = {
      kind = "source.addMissingImports",
      apply = "first",
    },
  })
end, { desc = "Add Missing Imports" })

vim.keymap.set("n", "<leader>co", function()
  action("editor.action.organizeImports")
  action("editor.action.sourceAction", {
    args = {
      kind = "source.removeUnusedImports",
      apply = "first",
    },
  })
end, { desc = "Optimize Imports" })
--#endregion

--#region Navigation
vim.keymap.set("n", "gd", function()
  action("editor.action.revealDefinition")
end, { desc = "Go to Definition" })

vim.keymap.set("n", "gr", function()
  action("editor.action.goToReferences")
end, { desc = "Go to References" })

vim.keymap.set("n", "gi", function()
  action("editor.action.goToImplementation")
end, { desc = "Go to Implementation" })

vim.keymap.set("n", "gD", function()
  action("editor.action.peekDefinition")
end, { desc = "Peek Definition" })

vim.keymap.set("n", "gy", function()
  action("editor.action.goToTypeDefinition")
end, { desc = "Go to Type Definition" })

vim.keymap.set("n", "K", function()
  action("editor.action.showHover")
end, { desc = "Show Hover" })

vim.keymap.set("n", "<C-o>", function()
  action("workbench.action.navigateBack")
end, { desc = "Navigate Back" })

vim.keymap.set("n", "<C-i>", function()
  action("workbench.action.navigateForward")
end, { desc = "Navigate Forward" })
--#endregion

--#region Window groups (LazyVim <C-hjkl>)
vim.keymap.set("n", "<C-h>", function()
  action("workbench.action.focusLeftGroup")
end, { desc = "Focus Left Group" })

vim.keymap.set("n", "<C-j>", function()
  action("workbench.action.focusBelowGroup")
end, { desc = "Focus Below Group" })

vim.keymap.set("n", "<C-k>", function()
  action("workbench.action.focusAboveGroup")
end, { desc = "Focus Above Group" })

vim.keymap.set("n", "<C-l>", function()
  action("workbench.action.focusRightGroup")
end, { desc = "Focus Right Group" })
--#endregion

--#region Diagnostics
vim.keymap.set("n", "<leader>cd", function()
  action("editor.action.marker.next")
end, { desc = "Next Diagnostic" })

vim.keymap.set("n", "<leader>cD", function()
  action("editor.action.marker.prev")
end, { desc = "Previous Diagnostic" })

vim.keymap.set("n", "<leader>cl", function()
  action("workbench.actions.view.problems")
end, { desc = "List Diagnostics" })

vim.keymap.set("n", "]d", function()
  action("editor.action.marker.next")
end, { desc = "Next Diagnostic" })

vim.keymap.set("n", "[d", function()
  action("editor.action.marker.prev")
end, { desc = "Prev Diagnostic" })
--#endregion

--#region File / find
vim.keymap.set("n", "<leader>ff", function()
  action("workbench.action.quickOpen")
end, { desc = "Find File" })

vim.keymap.set("n", "<leader>fg", function()
  action("workbench.action.findInFiles")
end, { desc = "Find in Files" })

vim.keymap.set("n", "<leader>fb", function()
  action("workbench.action.showAllEditorsByMostRecentlyUsed")
end, { desc = "Recent Buffers" })

vim.keymap.set("n", "<leader>fn", function()
  action("workbench.action.files.newUntitledFile")
end, { desc = "New File" })

vim.keymap.set("n", "<leader>fs", function()
  action("workbench.action.files.save")
end, { desc = "Save File" })

vim.keymap.set("n", "<leader>e", function()
  action("workbench.view.explorer")
end, { desc = "Explorer" })

vim.keymap.set("n", "<leader>fe", function()
  action("workbench.view.explorer")
end, { desc = "Explorer" })

vim.keymap.set("n", "<leader>E", function()
  action("workbench.action.toggleSidebarVisibility")
end, { desc = "Toggle Sidebar" })
--#endregion

--#region Buffers / editors
vim.keymap.set("n", "<leader>bd", function()
  action("workbench.action.closeActiveEditor")
end, { desc = "Close Editor" })

vim.keymap.set("n", "<leader>bo", function()
  action("workbench.action.closeOtherEditors")
end, { desc = "Close Other Editors" })

vim.keymap.set("n", "<leader>bb", function()
  action("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup")
end, { desc = "Other Buffer" })

vim.keymap.set("n", "<leader>`", function()
  action("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup")
end, { desc = "Other Buffer" })

vim.keymap.set("n", "<leader>qq", function()
  action("workbench.action.closeWindow")
end, { desc = "Quit Window" })
--#endregion

--#region Windows / splits
vim.keymap.set("n", "<leader>-", function()
  action("workbench.action.splitEditorDown")
end, { desc = "Split Down" })

vim.keymap.set("n", "<leader>|", function()
  action("workbench.action.splitEditorRight")
end, { desc = "Split Right" })

vim.keymap.set("n", "<leader>wd", function()
  action("workbench.action.closeActiveEditor")
end, { desc = "Delete Window" })
--#endregion

--#region Git
vim.keymap.set("n", "<leader>gg", open_lazygit, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>G", open_lazygit, { desc = "Lazygit" })
--#endregion

--#region Harpoon-ish editor indices
vim.keymap.set("n", "<leader>h", function()
  action("workbench.action.showAllEditors")
end, { desc = "All Editors" })

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    action("workbench.action.openEditorAtIndex" .. i)
  end, { desc = "Editor " .. i })
end
--#endregion

--#region UI toggles / folds
vim.keymap.set("n", "<leader>uw", function()
  action("editor.action.toggleWordWrap")
end, { desc = "Toggle Word Wrap" })

vim.keymap.set("n", "za", function()
  action("editor.toggleFold")
end, { desc = "Toggle Fold" })

vim.keymap.set("n", "zR", function()
  action("editor.unfoldAll")
end, { desc = "Unfold All" })

vim.keymap.set("n", "zM", function()
  action("editor.foldAll")
end, { desc = "Fold All" })
--#endregion
