if vim.g.vscode then
    -- NOTE: settings restricted to VSCode extension
    -- load in just settings and keymaps in VSCode
    -- not sure if this is completely safe because sets are in the same file
    require('winteragain.settings')
    require('winteragain.keymaps')
else
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

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

    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
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
    ---@diagnostic disable-next-line undefined-field
    vim.opt.rtp:prepend(lazypath)

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
            colorscheme = { 'mellifluous', 'tokyonight' }, -- try to load one of these colorschemes when starting an installation during startup
        },
    }
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
        local colorschemes = {
            'mellifluous',
            'tokyonight',
            'catppuccin',
            'rose-pine',
            'kanagawa',
            'winter-again',
        }
        vim.cmd('colorscheme ' .. colorschemes[cs_idx])
        vim.cmd('Transp')
    end

    colorize(1)
end
