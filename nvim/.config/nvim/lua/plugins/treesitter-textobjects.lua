return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = {'BufReadPost', 'BufNewFile'},
    config = function()
        require('nvim-treesitter.configs').setup({
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['af'] = {query='@function.outer', desc='Select outer part of function'},
                        ['if'] = {query='@function.inner', desc='Select inner part of function'},
                        ['ac'] = {query='@class.outer', desc='Select outer part of class'},
                        ['ic'] = {query='@class.inner', desc='Select inner part of class'}
                    }
                }
            }
        })
    end
}
