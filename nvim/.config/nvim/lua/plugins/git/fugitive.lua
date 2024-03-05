return {
    'tpope/vim-fugitive',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        local opts = { silent = true }
        Map('n', '<leader>gs', vim.cmd.Git, opts, 'Open fugitive buffer')
    end,
}
