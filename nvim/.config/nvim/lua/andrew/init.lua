-- reset cursor on exiting Neovim: line cursor and blinking
-- taken from here: https://github.com/alacritty/alacritty/issues/5450#issuecomment-929797364
-- local group = vim.api.nvim_create_augroup("ResetCursorOnExit", { clear = true })
-- vim.api.nvim_create_autocmd("ExitPre", { command = "set guicursor=a:ver90-blinkwait700-blinkoff400-blinkon250", group = group })

-- lazy.nvim for plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- recommended to set mapleader before lazy so that mappings are correct (if using keymap events to trigger plugin loading)
vim.g.mapleader = ' '

-- config lazy.nvim itself
-- stuff not specified here just get the default
local lazy_opts = {
    ui = {
        border = 'rounded'
    },
    change_detection = {
        enabled = true,
        notify = false
    },
    dev = {
        -- directory for local plugin dev
        path = '~/Documents/Projects/nvim-dev/internal'
    },
    install = {
        colorscheme = {'tokyonight'} -- try to load one of these colorschemes when starting an installation during startup
   }
}

-- get plugin specs from their individual files in the "plugins" directory
-- any file in lua/plugins/*.lua will be merged into the main plugin spec
require('lazy').setup('plugins', lazy_opts)
require('andrew.sets_and_remaps')

-- helpful for displaying Lua table contents
P = function(v)
    -- print(vim.inspect(v))
    print(vim.print(v))
    return v
end

-- currently no definition for Rmd files in iron.nvim
-- manually add it
require('iron.fts').rmd = {
    r = {
        command = {'R'} -- use R REPL for Rmd
    }
}
