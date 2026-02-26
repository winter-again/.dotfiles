return {
    {
        'echasnovski/mini.move',
        event = { 'BufReadPost', 'BufNewFile' },
        version = false,
        config = function()
            require('mini.move').setup({
                mappings = {
                    -- visual mode
                    up = 'K',
                    down = 'J',
                    left = 'H',
                    right = 'L',
                    -- normal mode defaults
                    line_up = '<M-k>',
                    line_down = '<M-j>',
                    line_left = '<M-h>',
                    line_right = '<M-l>',
                },
            })
        end,
    },
    {
        'echasnovski/mini.splitjoin',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('mini.splitjoin').setup({
                mappings = {
                    toggle = '<leader>sa',
                },
            })
        end,
    },
    {
        'echasnovski/mini.surround',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('mini.surround').setup()
        end,
    },
    {
        'echasnovski/mini.base16',
        version = false,
    },
}
