return {
    'kylechui/nvim-surround',
    -- version = '*' -- for stable; otherwise uses latest
    event = 'VeryLazy',
    config = function()
        require('nvim-surround').setup({
            keymaps = {
                normal = 'ss',
                change = 'sc',
                delete = 'sd'
            }
        })
    end
}
