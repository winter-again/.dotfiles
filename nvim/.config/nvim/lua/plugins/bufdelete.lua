return {
    'famiu/bufdelete.nvim',
    event = {'BufReadPost', 'BufReadPre'},
    config = function()
        vim.keymap.set('n', '<leader>db', ':Bdelete<CR>', {silent=true})
    end
}
