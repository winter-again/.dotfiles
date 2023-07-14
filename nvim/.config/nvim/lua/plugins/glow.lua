return {
    'ellisonleao/glow.nvim',
    ft = 'markdown',
    config = function()
        require('glow').setup({
            style = 'dark',
            border = 'rounded',
            width = 120
        })
    end
}
