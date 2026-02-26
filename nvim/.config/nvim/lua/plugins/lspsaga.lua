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
        local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { desc = desc, silent = true })
        end
        -- finder that shows defn, ref, and implementation
        nmap('gf', '<cmd>Lspsaga finder<CR>', 'LSP finder')
        -- rename all references to symbol under cursor
        nmap('<leader>rn', '<cmd>Lspsaga rename<CR>', 'Rename in file')
        -- code action
        nmap('<leader>ca', '<cmd>Lspsaga code_action<CR>', 'Code action')
    end,
}
