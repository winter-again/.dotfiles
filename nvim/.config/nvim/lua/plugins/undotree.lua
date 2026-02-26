return {
    -- problems with statuscol:
    -- {
    --     enabled = false,
    --     'mbbill/undotree',
    -- },
    {
        'jiaoshijie/undotree',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require('undotree').setup({
                window = {
                    winblend = 1,
                },
            })
            vim.keymap.set('n', '<leader>ut', require('undotree').toggle, { silent = true, desc = 'Toggle undotree' })
        end,
    },
}
