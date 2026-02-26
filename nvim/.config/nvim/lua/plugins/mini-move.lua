return {
    'echasnovski/mini.move',
    event = {'BufReadPost', 'BufNewFile'},
    version = false,
    enabled = true,
    config = function()
        require('mini.move').setup({
            mappings = {
                -- visual mode
                up = 'K',
                down = 'J',
                left = 'H',
                right = 'L',
                -- copying defaults for normal mode
                -- M is Alt
                line_up = '<M-k>',
                line_down = '<M-j>',
                line_left = '<M-h>',
                line_right = '<M-l>'
            }
        })
    end
}
