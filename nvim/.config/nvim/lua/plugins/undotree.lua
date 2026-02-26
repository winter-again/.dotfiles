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
            Map('n', '<leader>ut', require('undotree').toggle, { silent = true }, 'Toggle undotree')
        end,
    },
}
