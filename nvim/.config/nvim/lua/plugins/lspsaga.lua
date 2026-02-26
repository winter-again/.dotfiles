return {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-treesitter/nvim-treesitter', -- need markdown and markdown_inline parsers
    },
    config = function()
        require('lspsaga').setup({
            ui = {
                border = 'rounded',
            },
            symbol_in_winbar = {
                enable = false,
            },
            lightbulb = {
                enable = false,
            },
            scroll_preview = {
                scroll_down = '<C-f>',
                scroll_up = '<C-b>',
            },
            code_action = {
                show_server_name = true,
            },
        })
        -- finder that shows defn, ref, and implementation
        Map('n', '<leader>gf', '<cmd>Lspsaga finder<CR>', { silent = true }, 'LspSaga finder')
        -- rename all references to symbol under cursor
        Map('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true }, 'LspSaga rename')
        -- code action
        Map('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true }, 'LspSaga code action')
    end,
}
