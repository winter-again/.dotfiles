return {
    'famiu/bufdelete.nvim',
    event = {'BufReadPost', 'BufReadPre'},
    enabled = false,
    config = function()
        vim.keymap.set('n', '<leader>db', ':Bdelete<CR>', {silent=true})
    end
}
