return {
    {
        'echasnovski/mini.move',
        enabled = false,
        event = { 'BufReadPost', 'BufNewFile' },
        version = false,
        config = function()
            require('mini.move').setup({
                mappings = {
                    -- visual mode
                    up = 'K',
                    down = 'J',
                    left = 'H',
                    right = 'L',
                    -- normal mode defaults
                    line_up = '<M-k>',
                    line_down = '<M-j>',
                    line_left = '<M-h>',
                    line_right = '<M-l>',
                },
            })
        end,
    },
    {
        'echasnovski/mini.splitjoin',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('mini.splitjoin').setup({
                mappings = {
                    toggle = '<leader>sa',
                },
            })
        end,
    },
    {
        'echasnovski/mini.surround',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('mini.surround').setup()
        end,
    },
    -- alt to nvim-tree
    {
        'echasnovski/mini.files',
        enabled = false,
        version = false,
        config = function()
            local map_split = function(buf_id, lhs, direction)
                local rhs = function()
                    -- Make new window and set it as target
                    local new_target_window
                    vim.api.nvim_win_call(require('mini.files').get_target_window(), function()
                        vim.cmd(direction .. ' split')
                        new_target_window = vim.api.nvim_get_current_win()
                    end)

                    require('mini.files').set_target_window(new_target_window)
                end

                -- Adding `desc` will result into `show_help` entries
                local desc = 'Split ' .. direction
                vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
            end

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local buf_id = args.data.buf_id
                    -- Tweak keys to your liking
                    map_split(buf_id, 'sh', 'belowright horizontal')
                    map_split(buf_id, 'sv', 'belowright vertical')
                end,
            })

            require('mini.files').setup()
            vim.keymap.set('n', '<leader>ll', '<cmd>lua MiniFiles.open()<CR>')
        end,
    },
}
