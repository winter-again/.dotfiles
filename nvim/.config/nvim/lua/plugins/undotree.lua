return {
    {
        "mbbill/undotree",
        enabled = true,
        config = function()
            vim.keymap.set("n", "<leader>ut", "<cmd>UndotreeToggle<CR>", { silent = true, desc = "Toggle undo tree" })
        end,
    },
    -- {
    --     'jiaoshijie/undotree',
    --     enabled = false,
    --     dependencies = 'nvim-lua/plenary.nvim',
    --     config = function()
    --         require('undotree').setup({
    --             window = {
    --                 winblend = 1,
    --             },
    --         })
    --         vim.keymap.set('n', '<leader>ut', require('undotree').toggle, { silent = true, desc = 'Toggle undotree' })
    --     end,
    -- },
}
