-- -----------------------------------------------------------------------------
-- Defines custom keyboard shortcuts used throughout Neovim.
-- -----------------------------------------------------------------------------

-- Saves the current file by pressing Escape in Normal mode.
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })

-- Selects the entire buffer.
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select All' })

-- Keeps the clipboard unchanged when pasting over a visual selection.
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])