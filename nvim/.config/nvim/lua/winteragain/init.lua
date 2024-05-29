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
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
-- recommended to set mapleader before lazy so that mappings are correct
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- config lazy.nvim itself
local lazy_opts = {
    ui = {
        border = 'none',
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    checker = {
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

-- ft edits
-- incl. workaround for some kind of highlighting in .mdx files
-- based on: https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
vim.filetype.add({
    -- based on extension
    extension = {
        mdx = 'mdx',
        log = 'log',
        conf = 'conf',
        env = 'dotenv',
    },
    -- based on entire filename
    filename = {
        ['.env'] = 'dotenv',
        ['env'] = 'dotenv',
        ['tsconfig.json'] = 'jsonc',
    },
    pattern = {},
})
-- use markdown parser for mdx files
vim.treesitter.language.register('markdown', { 'mdx' })

-- NOTE: consider moving these "default" things to plugin/ dir
-- (automatically sourced after lazy config loaded)
-- advantage of current way is that I have finer control
-- over what gets required and the order
require('winteragain.settings')
require('winteragain.autocmds')
require('winteragain.globals')
require('winteragain.keymaps')
-- get plugin specs from their individual files in the plugins directory
-- any file in lua/plugins/*.lua will be merged into the main plugin spec
-- require('lazy').setup('plugins', lazy_opts)

-- to load subdirs of lua/plugins
-- have to import the dirs
require('lazy').setup({
    { import = 'plugins' },
    { import = 'plugins.code' },
    { import = 'plugins.git' },
}, lazy_opts)

---Set colorscheme and transparent background
---@param cs_idx number
local function colorize(cs_idx)
    -- top colorschemes
    local colorschemes = {
        'tokyonight',
        'catppuccin',
        'rose-pine',
        'kanagawa',
        'mellifluous',
        'boo',
        'winter-again',
    }
    vim.cmd('colorscheme ' .. colorschemes[cs_idx])
    vim.cmd('Transp')
end

colorize(5)
