return {
    'winter-again/annotate.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    -- branch = 'customize-db-location',
    dev = true,
    -- enabled = true,
    config = function()
        require('annotate').setup({
            -- db_uri = vim.fn.stdpath('data') .. '/annotations_db', -- default
            db_uri = vim.fn.stdpath('data') .. '/test_db',
            -- sign column symbol to use
            annot_sign = '󰍕',
            -- highlight group for symbol
            annot_sign_hl = 'Comment',
            -- highlight group for currently active annotation
            annot_sign_hl_current = 'FloatBorder',
            -- width of floating annotation window
            annot_win_width = 25,
            -- padding to the right of the floating annotation window
            annot_win_padding = 2,
        })
        vim.keymap.set('n', '<leader>ac', '<cmd>lua require("annotate").create_annotation()<cr>')
        vim.keymap.set('n', '<leader>ad', '<cmd>lua require("annotate").delete_annotation()<cr>')
    end,
}
