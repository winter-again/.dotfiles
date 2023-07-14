return {
    'folke/trouble.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        require('trouble').setup({
            -- action_keys = {
            --     -- can remove defaults here
            -- },
            -- signs = {
            --       -- icons / text used for a diagnostic
            --       error = "",
            --       warning = "",
            --       hint = "",
            --       information = "",
            --       other = "",
            --     },
            use_diagnostic_signs = true
        })
        vim.keymap.set('n', '<leader>tt', '<cmd>TroubleToggle<CR>', {silent=true})
        vim.keymap.set('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<CR>', {silent=true})
        vim.keymap.set('n', '<leader>td', '<cmd>TroubleToggle document_diagnostics<CR>', {silent=true})
    end
}
