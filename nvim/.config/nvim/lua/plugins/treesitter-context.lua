return {
    'nvim-treesitter/nvim-treesitter-context',
    event = {'BufReadPost', 'BufNewFile'},
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
        require('treesitter-context').setup({
            enable = true,
            max_lines = 4
        })
    end
}
