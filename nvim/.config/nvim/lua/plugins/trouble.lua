return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('trouble').setup({
            use_diagnostic_signs = true,
        })
        local opts = { silent = true }
        Map('n', '<leader>tt', '<cmd>TroubleToggle<CR>', opts, 'Toggle Trouble')
        Map(
            'n',
            '<leader>tw',
            '<cmd>TroubleToggle workspace_diagnostics<CR>',
            opts,
            'Toggle Trouble workspace diagnostics'
        )
        Map(
            'n',
            '<leader>td',
            '<cmd>TroubleToggle document_diagnostics<CR>',
            opts,
            'Toggle Trouble document diagnostics'
        )
    end,
}
