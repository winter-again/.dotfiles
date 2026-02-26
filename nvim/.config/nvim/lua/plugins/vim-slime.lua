return {
    'jpalardy/vim-slime',
    config = function()
        vim.g.slime_target = 'tmux'
        vim.g.slime_bracketed_paste = 1
        vim.g.slime_default_config = { socket_name = 'default', target_pane = '{last}' }
        vim.g.slime_dont_ask_default = 1

        -- TODO: make this detect filetype and start appropriate REPL
        -- also set up better keymaps for sending lines, visual selections, etc.
        vim.keymap.set('n', '<leader><leader>s', function()
            vim.fn['slime#send'](table.concat({ 'R', '\r' }))
        end)
        vim.keymap.set('n', '<leader><leader>q', function()
            vim.fn['slime#send'](table.concat({ 'q()', '\r' }))
        end)
        -- clear R REPL
        vim.keymap.set('n', '<leader><leader>c', function()
            vim.fn['slime#send'](table.concat({ 'cat(c("\\033[2J","\\033[0;0H"))', '\r' }))
        end)
    end,
}
