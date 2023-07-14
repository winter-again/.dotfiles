return {
    'numToStr/Comment.nvim',
    event = {'BufReadPost', 'BufNewFile'},
    config = function()
        require('Comment').setup({
            toggler = {
                line = '<C-/>' -- default = 'gcc'; toggles current line as comment
            },
            opleader = {
                line = '<C-/>' -- default = 'gc'; toggles the region as a comment
            },
            extra = {
                eol = 'gce' -- default = 'gcA'; adds comment at end of the line and enter Insert mode
            },
            -- integration with nvim-ts-context-commentstring
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        })
    end
}
