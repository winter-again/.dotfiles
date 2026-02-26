return {
    'MeanderingProgrammer/markdown.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    enabled = false,
    config = function()
        require('render-markdown').setup({
            code = {
                style = 'language',
            },
            bullet = {
                icons = { '', '', '', '' },
            },
        })
    end,
}
