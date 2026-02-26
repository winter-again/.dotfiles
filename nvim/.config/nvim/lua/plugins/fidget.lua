return {
    'j-hui/fidget.nvim',
    config = function()
        require('fidget').setup({
            notification = {
                window = {
                    normal_hl = 'Comment',
                    winblend = 0,
                },
            },
        })
        Map('n', '<leader><leader>sf', '<cmd>Fidget suppress<CR>', { silent = true }, 'Toggle fidget.nvim')
    end,
}
