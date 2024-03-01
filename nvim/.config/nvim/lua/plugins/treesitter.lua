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
                        -- lookahead = true,
                        keymaps = {
                            ['af'] = { query = '@function.outer', desc = 'Select around function' },
                            ['if'] = { query = '@function.inner', desc = 'Select inside function' },
                            ['ac'] = { query = '@class.outer', desc = 'Select around class' },
                            ['ic'] = { query = '@class.inner', desc = 'Select inside class' },
                            -- trying to capture markdown fenced code blocks/content
                            -- seems to behave incorrectly when there's a Python function defn in the block
                            -- 'vib' fails to include the function defn. line
                            -- or at least it behaves strangely dep on cursor loc in the block...
                            ['ab'] = { query = '@block.outer', desc = 'Select around code block' },
                            ['ib'] = { query = '@block.inner', desc = 'Select inside code block' },
                        },
                    },
                    move = {
                        enable = true,
                        goto_next_start = {
                            [']b'] = '@block.outer',
                        },
                        goto_previous_start = {
                            ['[b'] = '@block.outer',
                        },
                    },
                },
                additional_vim_regex_highlighting = false,
            })
            Map('n', '<leader>tsp', '<cmd>InspectTree<CR>', { silent = true }, 'Show parsed syntax tree')
            Map('n', '<leader>tsh', '<cmd>Inspect<CR>', { silent = true }, 'Show highlight groups under cursor')
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
