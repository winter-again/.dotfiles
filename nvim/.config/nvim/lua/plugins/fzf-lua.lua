return {
    'ibhagwan/fzf-lua',
    enabled = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('fzf-lua').setup({})
    end,
}
