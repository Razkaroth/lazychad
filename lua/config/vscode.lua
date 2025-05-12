local vscode = require('vscode')

-- LSP and Code Actions
vim.keymap.set('n', '<leader>ca', function()
  vscode.action('editor.action.quickFix')
end, { desc = 'Code Action' })

vim.keymap.set('n', '<leader>cr', function()
  vscode.action('editor.action.rename')
end, { desc = 'Rename Symbol' })

vim.keymap.set('n', '<leader>cf', function()
  vscode.action('editor.action.formatDocument')
end, { desc = 'Format Document' })

-- Navigation
vim.keymap.set('n', 'gd', function()
  vscode.action('editor.action.revealDefinition')
end, { desc = 'Go to Definition' })

vim.keymap.set('n', 'gr', function()
  vscode.action('editor.action.goToReferences')
end, { desc = 'Go to References' })

vim.keymap.set('n', 'gi', function()
  vscode.action('editor.action.goToImplementation')
end, { desc = 'Go to Implementation' })

vim.keymap.set('n', 'gD', function()
  vscode.action('editor.action.peekDefinition')
end, { desc = 'Peek Definition' })

-- Diagnostics
vim.keymap.set('n', '<leader>cd', function()
  vscode.action('editor.action.marker.next')
end, { desc = 'Next Diagnostic' })

vim.keymap.set('n', '<leader>cD', function()
  vscode.action('editor.action.marker.prev')
end, { desc = 'Previous Diagnostic' })

vim.keymap.set('n', '<leader>cl', function()
  vscode.action('workbench.actions.view.problems')
end, { desc = 'List Diagnostics' })

-- File Navigation
vim.keymap.set('n', '<leader>ff', function()
  vscode.action('workbench.action.quickOpen')
end, { desc = 'Find File' })

vim.keymap.set('n', '<leader>fg', function()
  vscode.action('workbench.action.findInFiles')
end, { desc = 'Find in Files' })

vim.keymap.set('n', '<leader>fb', function()
  vscode.action('workbench.action.showAllEditorsByMostRecentlyUsed')
end, { desc = 'Recent Buffers' })

-- Auto-import
vim.keymap.set('n', '<leader>ci', function()
  vscode.action('editor.action.sourceAction', {
    args = { kind = 'source.addMissingImports' }
  })
end, { desc = 'Add Missing Imports' })

-- Organize imports
vim.keymap.set('n', '<leader>co', function()
  vscode.action('editor.action.organizeImports')
end, { desc = 'Organize Imports' })

-- Hover documentation
vim.keymap.set('n', 'K', function()
  vscode.action('editor.action.showHover')
end, { desc = 'Show Hover' })

-- Code folding
vim.keymap.set('n', 'za', function()
  vscode.action('editor.toggleFold')
end, { desc = 'Toggle Fold' })

vim.keymap.set('n', 'zR', function()
  vscode.action('editor.unfoldAll')
end, { desc = 'Unfold All' })

vim.keymap.set('n', 'zM', function()
  vscode.action('editor.foldAll')
end, { desc = 'Fold All' })

-- Terminal
vim.keymap.set('n', '<leader>ft', function()
  vscode.action('workbench.action.terminal.toggleTerminal')
end, { desc = 'Toggle Terminal' })

-- File operations
vim.keymap.set('n', '<leader>fn', function()
  vscode.action('workbench.action.files.newUntitledFile')
end, { desc = 'New File' })

vim.keymap.set('n', '<leader>fs', function()
  vscode.action('workbench.action.files.save')
end, { desc = 'Save File' }) 



-- source options
vim.keymap.set('n', '<leader>co', function()
  vscode.action('editor.action.organizeImports')
  -- Remove unused imports
  vscode.action('editor.action.sourceAction', {
    args = { 
      kind = 'source.removeUnusedImports',
      apply = "first"
     }
  })
end, { desc = 'Optimize imports' })

vim.keymap.set('n', '<leader>ci', function()
  vscode.action('editor.action.sourceAction', {
    args = { 
      kind = 'source.addMissingImports',
      apply = "first"
     }
  })
end, { desc = 'Add missing imports' })
