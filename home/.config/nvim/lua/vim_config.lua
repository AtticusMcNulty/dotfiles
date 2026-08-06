-- -----------------------------------------------------------------------------
-- Configures Neovim's built-in editor behavior, including indentation,
-- searching, line numbers, clipboard integration, and other editing defaults.
-- -----------------------------------------------------------------------------

local o = vim.opt

-- Uses Space as the leader key for custom shortcuts.
vim.g.mapleader = ' '

-- Configures the default editing behavior.
o.expandtab = true          -- Inserts spaces instead of tabs.
o.shiftwidth = 2            -- Uses two spaces for each indentation level.
o.number = true             -- Shows the current line number.
o.relativenumber = true     -- Shows relative line numbers for other lines.
o.ignorecase = true         -- Makes searches case-insensitive by default.
o.smartcase = true          -- Makes searches case-sensitive when uppercase is used.
o.clipboard = 'unnamedplus' -- Shares the clipboard with the operating system.
o.scrolloff = 16            -- Keeps the cursor away from the top and bottom of the screen.
o.undofile = true           -- Persists undo history across sessions.

-- Disables mouse support so Neovim stays keyboard-driven and lets Herdr keep
-- host mouse capture disabled, preventing Escape from being swallowed.
-- o.mouse = ''