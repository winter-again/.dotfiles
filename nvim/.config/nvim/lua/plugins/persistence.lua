return {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    enabled = false,
    config = function()
        require('persistence').setup({
            options = {'buffers', 'curdir', 'tabpages', 'winsize'}
        })
        vim.keymap.set('n', '<leader>pr', "<cmd>lua require('persistence').load()<cr>", {silent=true}) -- load session for current dir
        vim.keymap.set('n', '<leader>pl', "<cmd>lua require('persistence').load({last=true})<cr>", {silent=true}) -- load last session
    end
}
