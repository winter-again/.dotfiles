return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = {'BufReadPost', 'BufNewFile'},
    dependencies = 'JoosepAlviste/nvim-ts-context-commenstring',
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
                'regex'
            },
            sync_install = false, -- synchronous install of parsers (only applied to ensure_installed)
            auto_install = false, -- recommended to set false if don't have tree-sitter CLI installed locally
            highlight = {
                enable = true, -- false will disable the whole extension
            },
            indent = {
                enable = true, -- still experimental; Python supp under dev
                -- disable = {'r'}
            },
            additional_vim_regex_highlighting = false,
            context_commentstring = {
                enable = true,
                enable_autocmd = false
            }
        })
    end
}
