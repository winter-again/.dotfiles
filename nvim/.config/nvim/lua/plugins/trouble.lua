return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('trouble').setup({
            use_diagnostic_signs = true,
        })
        vim.keymap.set('n', '<leader>tt', '<cmd>TroubleToggle<CR>', { silent = true })
        vim.keymap.set('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<CR>', { silent = true })
        vim.keymap.set('n', '<leader>td', '<cmd>TroubleToggle document_diagnostics<CR>', { silent = true })
    end,
}
