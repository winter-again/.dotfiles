return {
    'Vigemus/iron.nvim',
    ft = { 'python', 'r' }, -- I think overridden because of the Rmd stuff in init.lua
    enabled = false,
    config = function()
        local iron = require('iron.core')
        local view = require('iron.view')
        iron.setup({
            config = {
                scratch_repl = true,
                close_window_on_exit = true,
                repl_open_cmd = view.split.vertical.botright(0.45),
                repl_definition = {
                    python = require('iron.fts.python').ipython,
                    -- r = {
                    --     -- command = {'radian'},
                    --     -- format = require('iron.fts.common').bracketed_paste
                    -- }
                },
            },
            keymaps = {
                visual_send = '<leader>sc', -- send visual selection
                send_line = '<leader>sl', -- send line
                send_file = '<leader>sf', -- send file
                send_until_cursor = '<leader>su', -- send until cursor
                interrupt = '<leader>st', -- interrupt REPL
            },
            highlight_last = 'IronLastSent', -- highlight last send block
            highlight = {
                italic = true, -- use italics instead of bold
            },
            ignore_blank_lines = false,
        })
        vim.keymap.set('n', '<leader>si', '<cmd>IronReplHere<CR>', { silent = true })
        vim.keymap.set('n', '<leader>ss', '<cmd>IronRepl<CR>', { silent = true })
    end,
}
