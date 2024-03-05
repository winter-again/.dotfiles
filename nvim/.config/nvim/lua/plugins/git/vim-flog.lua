return {
    'rbong/vim-flog',
    lazy = true,
    dependencies = 'tpope/vim-fugitive',
    cmd = { 'Flog', 'Flogsplit', 'Floggit' },
    keys = { '<leader>gg' },
    config = function()
        Map('n', '<leader>gg', '<cmd>Flogsplit<CR>', { silent = true }, 'Open Flog split of git log graph')
    end,
}
