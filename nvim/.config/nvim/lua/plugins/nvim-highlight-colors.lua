return {
    'brenoprata10/nvim-highlight-colors',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('nvim-highlight-colors').setup({
            ---@usage 'background' | 'foreground' | 'virtual'
            render = 'virtual',
            virtual_symbol = '󱓻',
            enable_named_colors = true,
            enable_tailwind = true,
            formatting = {
                -- colors in cmp?
                format = require('nvim-highlight-colors').format,
            },
        })
    end,
}
