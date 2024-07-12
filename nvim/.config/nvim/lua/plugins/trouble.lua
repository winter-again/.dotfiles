return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('trouble').setup({
            open_no_results = true,
            modes = {
                symbols = {
                    win = { position = 'bottom' },
                },
                lsp = {
                    win = { position = 'bottom' },
                },
            },
        })
        vim.keymap.set(
            'n',
            '<leader>tt',
            '<cmd>Trouble diagnostics toggle<CR>',
            { silent = true, desc = 'Toggle Trouble diagnostics' }
        )
        vim.keymap.set(
            'n',
            '<leader>tb',
            '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
            { silent = true, desc = 'Toggle Trouble document diagnostics' }
        )
        vim.keymap.set(
            'n',
            '<leader>ts',
            '<cmd>Trouble symbols toggle<CR>',
            { silent = true, desc = 'Trouble symbols' }
        )
        vim.keymap.set('n', '<leader>tl', '<cmd>Trouble qflist toggle<CR>', { silent = true, desc = 'Trouble qflist' })
    end,
}
