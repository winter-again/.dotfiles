return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('trouble').setup({
            use_diagnostic_signs = true,
        })
        vim.keymap.set('n', '<leader>tt', '<cmd>TroubleToggle<CR>', { silent = true, desc = 'Toggle Trouble' })
        vim.keymap.set(
            'n',
            '<leader>tw',
            '<cmd>TroubleToggle workspace_diagnostics<CR>',
            { silent = true, desc = 'Toggle Trouble workspace diagnostics' }
        )
        vim.keymap.set(
            'n',
            '<leader>td',
            '<cmd>TroubleToggle document_diagnostics<CR>',
            { silent = true, desc = 'Toggle Trouble document diagnostics' }
        )
    end,
}
