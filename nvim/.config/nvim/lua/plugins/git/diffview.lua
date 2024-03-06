return {
    'sindrets/diffview.nvim',
    -- event = { 'BufReadPost', 'BufNewFile' },
    keys = { '<space>dv' },
    config = function()
        Map('n', '<leader>dv', '<cmd>DiffviewOpen<CR>', { silent = true }, 'Open Diffview')
        Map('n', '<leader>df', '<cmd>DiffviewFileHistory<CR>', { silent = true }, 'Open Diffview')
    end,
}
