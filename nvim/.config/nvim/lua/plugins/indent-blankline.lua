return {
    'lukas-reineke/indent-blankline.nvim',
    event = {'BufReadPost', 'BufNewFile'},
    -- version = '2.20.8',
    -- pin = true,
    -- config = function()
    --     require('indent_blankline').setup({
    --         -- char = '▏', -- U+258F (1/8 block); the default is '│'; note that it blocks insert mode cursor
    --         -- context_char = '▎', -- U+258E (1/4 block)
    --         show_current_context = true, -- highlight current context indent
    --     })
    -- end
    main = 'ibl',
    config = function()
        require('ibl').setup({
            indent = {
                char = '│'
            },
            scope = {
                char = '│',
                show_start = false,
                show_end = false
            }
        })
    end
}
