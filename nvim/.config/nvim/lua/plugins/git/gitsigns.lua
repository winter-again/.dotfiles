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
                local function map(mode, l, r, opts, desc)
                    opts = opts or {}
                    opts.buffer = bufnr
                    opts.desc = desc
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
                map('n', '<leader>gb', gs.toggle_current_line_blame, opts, 'Toggle git blame for current line')
                -- map('n', '<leader>hd', gs.diffthis, opts, 'Diff this file')
                map('n', '<leader>td', gs.toggle_deleted, opts, 'Toggle showing deletions inline')

                map('n', '<leader>hd', gs.preview_hunk, opts, 'Show hunk diff')
                map('n', '<leader>hs', gs.stage_hunk, opts, 'Stage hunk')
                map('v', '<leader>hs', function()
                    gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, opts, 'Stage hunk')
                map('n', '<leader>hu', gs.undo_stage_hunk, opts, 'Undo stage hunk')
                map('n', '<leader>hr', gs.reset_hunk, opts, 'Reset hunk')
                map('v', '<leader>hr', function()
                    gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, opts, 'Reset hunk')
            end,
            preview_config = {
                border = 'none',
            },
        })
    end,
}
