return {
    'folke/persistence.nvim',
    -- enabled = false,
    event = 'BufReadPre',
    config = function()
        require('persistence').setup({
            options = { 'buffers', 'curdir', 'winpos', 'winsize' },
        })
    end,
}
