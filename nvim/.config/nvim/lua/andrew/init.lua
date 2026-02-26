local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- recommended to set mapleader before lazy so that mappings are correct
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- config lazy.nvim itself
local lazy_opts = {
    ui = {
        border = 'rounded',
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    dev = {
        path = '~/Documents/code/nvim-dev',
    },
    install = {
        colorscheme = { 'tokyonight' }, -- try to load one of these colorschemes when starting an installation during startup
    },
}

require('andrew.globals')
require('andrew.settings')
require('andrew.autocmds')
-- get plugin specs from their individual files in the plugins directory
-- any file in lua/plugins/*.lua will be merged into the main plugin spec
require('lazy').setup('plugins', lazy_opts)
require('andrew.keymaps') -- some of the keymaps defined here rely on plugins

vim.opt.background = 'dark'
-- vim.cmd('colorscheme winter-again')
vim.cmd('colorscheme tokyonight')
vim.cmd('Transp')
