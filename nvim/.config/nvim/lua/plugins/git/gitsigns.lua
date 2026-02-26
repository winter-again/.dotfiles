return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('gitsigns').setup({
            current_line_blame_opts = {
                delay = 500,
            },
            current_line_blame_formatter = '<author> • <author_time:%Y-%m-%d> • <summary>',
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                -- nav between hunks
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end
                map('n', ']h', function()
                    if vim.wo.diff then
                        return ']h'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true })

                map('n', '[h', function()
                    if vim.wo.diff then
                        return '[h'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true })

                local opts = { silent = true }
                vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, opts)
                -- diff: working tree vs. index
                -- vim.keymap.set('n', '<leader>gd', gs.diffthis, opts)
                -- diff: working tree vs. the last commit
                vim.keymap.set('n', '<leader>gD', function()
                    gs.diffthis('~')
                end, opts)
                -- vim.keymap.set('n', '<leader>gd', gs.toggle_deleted, opts)
                vim.keymap.set('n', '<leader>ghs', gs.stage_hunk, opts)
                vim.keymap.set('n', '<leader>ghu', gs.undo_stage_hunk, opts)
                vim.keymap.set('n', '<leader>ghr', gs.reset_hunk, opts)
                vim.keymap.set('v', '<leader>ghs', function()
                    gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, opts)
                vim.keymap.set('v', '<leader>ghr', function()
                    gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, opts)
                vim.keymap.set('n', '<leader>ghp', gs.preview_hunk, opts)
            end,
            preview_config = {
                border = 'none',
            },
        })
    end,
}
