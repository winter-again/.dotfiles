--- @diagnostic disable: missing-fields
return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            require('nvim-treesitter.configs').setup({
                -- first 5 are advised to always be installed
                ensure_installed = {
                    'astro',
                    'bash',
                    'c',
                    'css',
                    'git_config',
                    'git_rebase',
                    'gitattributes',
                    'gitcommit',
                    'gitignore',
                    'go',
                    'gomod',
                    'html',
                    'javascript',
                    'json',
                    'lua',
                    'markdown',
                    'markdown_inline',
                    'python',
                    'query',
                    'r',
                    'rasi',
                    'regex',
                    'sql',
                    'toml',
                    'tsx',
                    'typescript',
                    'vim',
                    'vimdoc',
                    'yaml',
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
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            require('treesitter-context').setup({
                enable = true,
                max_lines = 4,
            })
        end,
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            vim.g.skip_ts_context_commentstring_module = true -- skip backwards compat checks for faster loading
            require('ts_context_commentstring').setup({})
        end,
    },
}
