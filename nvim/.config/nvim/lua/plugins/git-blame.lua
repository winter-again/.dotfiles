return {
    'f-person/git-blame.nvim',
    event = {'BufReadPost', 'BufNewFile'},
    enabled = false, -- using gitsigns built-in functionality for now
    init = function()
        vim.g.gitblame_message_template = ' <author> • <date> • <summary>'
        vim.g.gitblame_enabled = 0
    end
}
