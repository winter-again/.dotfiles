--- @diagnostic disable: missing-fields
return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
        require('nvim-treesitter.configs').setup({
            -- first 5 are advised to always be installed
            ensure_installed = {
                'c',
                'lua',
                'vim',
                'vimdoc',
                'query',
                'html',
                'css',
                'javascript',
                'typescript',
                'json',
                'tsx',
                'astro',
                'python',
                'r',
                'go',
                'gomod',
                'markdown',
                'markdown_inline',
                'sql',
                'git_config',
                'git_rebase',
                'gitattributes',
                'gitcommit',
                'gitignore',
                'toml',
                'yaml',
                'bash',
                'rasi',
                'regex',
            },
            sync_install = false, -- synchronous install of parsers (only applied to ensure_installed)
            auto_install = false, -- recommended to set false if don't have tree-sitter CLI installed locally
            highlight = {
                enable = true, -- false will disable the whole extension
            },
            indent = {
                enable = true, -- still experimental; Python supp under dev
                disable = { 'r' },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['af'] = { query = '@function.outer', desc = 'Select outer part of function' },
                        ['if'] = { query = '@function.inner', desc = 'Select inner part of function' },
                        ['ac'] = { query = '@class.outer', desc = 'Select outer part of class' },
                        ['ic'] = { query = '@class.inner', desc = 'Select inner part of class' },
                    },
                },
            },
            additional_vim_regex_highlighting = false,
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
        })
    end,
}
