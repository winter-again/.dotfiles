return {
    'olimorris/persisted.nvim',
    enabled = true,
    config = function()
        require('persisted').setup()
        vim.keymap.set('n', '<leader>ps', '<cmd>SessionSave<CR>', {silent=true})
        vim.keymap.set('n', '<leader>pr', '<cmd>SessionLoad<CR>', {silent=true}) -- session for current dir and current branch
        vim.keymap.set('n', '<leader>pl', '<cmd>SessionLoadLast<CR>', {silent=true}) -- most recent session
    end
}
