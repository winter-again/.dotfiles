return {
    'tpope/vim-fugitive',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { silent = true })
    end,
}
