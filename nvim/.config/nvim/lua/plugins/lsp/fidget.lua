return {
    'j-hui/fidget.nvim',
    -- enabled = false,
    config = function()
        require('fidget').setup({
            notification = {
                window = {
                    normal_hl = 'Comment',
                    winblend = 0,
                },
            },
            integration = {
                ['nvim-tree'] = {
                    enable = false, -- don't need since nvim-tree is kept on left
                },
            },
        })
    end,
}
