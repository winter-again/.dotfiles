return {
    'kevinhwang91/nvim-hlslens',
    event = {'BufReadPost', 'BufNewFile'},
    config = function()
        require('hlslens').setup({
            calm_down = false -- true will clear all lens and highlighting when cursor is out of position range or any text changed
        })
        local opts = {silent = true}
        -- jump through results
        vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
        -- support for
        -- '*' = find previous occurrence of word under cursor
        -- '#' = find next occurrence of word under cursor
        vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
        -- like the above but allows partial matching of word
        vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', '<leader>l', '<Cmd>noh<CR>', opts) -- to turn off the mode
    end
}
