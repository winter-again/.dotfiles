return {
    'sindrets/diffview.nvim',
    -- event = { 'BufReadPost', 'BufNewFile' },
    keys = { '<space>dv' },
    config = function()
        vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewOpen<CR>', { silent = true, desc = 'Open Diffview' })
        vim.keymap.set('n', '<leader>df', '<cmd>DiffviewFileHistory<CR>', { silent = true, desc = 'Open Diffview' })
    end,
}
