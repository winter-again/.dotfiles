local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
-- recommended to set mapleader before lazy so that mappings are correct
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- config lazy.nvim itself
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
        path = '~/Documents/projects/nvim-dev/internal'
    },
    install = {
        colorscheme = {'tokyonight'} -- try to load one of these colorschemes when starting an installation during startup
   }
}
-- get plugin specs from their individual files in the plugins directory
-- any file in lua/plugins/*.lua will be merged into the main plugin spec
require('lazy').setup('plugins', lazy_opts)
require('andrew.sets_and_remaps')
-- global functions/settings
-- helpful for displaying Lua table contents
P = function(v)
    -- print(vim.inspect(v))
    print(vim.print(v))
    return v
end
-- currently no definition for Rmd files in iron.nvim
require('iron.fts').rmd = {
    r = {
        command = {'R'}
    }
}
-- transparency
Transp = function()
    local highlights = {
        'Normal',
        -- 'NormalNC', -- seems to work w/o this
        -- 'NormalFloat', -- affects docs pop-up
        -- 'Float',
        'FloatTitle',
        'SignColumn',
        'FoldColumn'
    }
    for _, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl, {bg='none'})
    end
end

Transp()
