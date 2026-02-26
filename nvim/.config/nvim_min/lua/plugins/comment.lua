return {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('Comment').setup({
            -- note that these are set using "_" but are actually targeting "/"
            toggler = {
                line = '<C-_>',
            },
            opleader = {
                line = '<C-_>',
            },
            extra = {
                eol = 'gce',
            },
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        })
    end,
}
