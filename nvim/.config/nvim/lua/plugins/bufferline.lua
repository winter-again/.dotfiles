return {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    enabled = true,
    config = function()
        require('bufferline').setup({
            options = {
                mode = 'buffers',
                offsets = {
                    {filetype = 'NvimTree', text = 'NvimTree', text_align = 'center'}
                },
                modified_icon = '[+]',
                -- config the bdelete command to NOT force deletion and lose unsaved changes
                close_command = 'Bdelete', -- really only used for the two commands that bufferline adds (closing buffers to the left and right of current buffer)
                right_mouse_command = 'Bdelete',
                indicator = {
                    style = 'icon'
                },
                groups = {
                    items = {
                        require('bufferline.groups').builtin.pinned:with({icon = ''})
                    }
                },
                separator_style = 'slope',
                always_show_bufferline = false,
                show_buffer_icons = true,
                show_buffer_close_icons = false,
                diagnostics = false,
                color_icons = false
            },
            highlights = {
                buffer_selected = {
                    bold = false
                }
            }
        })
        vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', {silent = true})
        vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', {silent = true})
        vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', {silent = true})
        vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineMovePrev<CR>', {silent = true})
        vim.keymap.set('n', '<leader>br', '<cmd>BufferLineMoveNext<CR>', {silent = true})
    end
}
