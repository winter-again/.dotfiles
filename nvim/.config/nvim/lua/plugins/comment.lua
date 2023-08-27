return {
    'numToStr/Comment.nvim',
    event = {'BufReadPost', 'BufNewFile'},
    config = function()
        require('Comment').setup({
            toggler = {
                line = '<C-/>'
            },
            opleader = {
                line = '<C-/>'
            },
            extra = {
                eol = 'gce'
            },
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        })
    end
}
