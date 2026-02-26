return {
    'ibhagwan/fzf-lua',
    enabled = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('fzf-lua').setup({})
        Map('n', '<leader>fzf', '<cmd>lua require("fzf-lua").files()<CR>', { silent = true }, 'fzf-lua')
    end,
}
