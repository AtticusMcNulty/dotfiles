-- -----------------------------------------------------------------------------
-- Bootstraps the lazy.nvim plugin manager if it isn't already installed, then
-- loads every plugin defined under lua/plugins/.
-- -----------------------------------------------------------------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Installs lazy.nvim the first time Neovim starts.
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

-- Makes lazy.nvim available to Neovim.
vim.opt.rtp:prepend(lazypath)

-- Loads every plugin definition in lua/plugins/.
require('lazy').setup('plugins')