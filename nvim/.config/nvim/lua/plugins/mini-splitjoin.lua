return {
    'echasnovski/mini.splitjoin',
    version = false,
    event = {'BufReadPost', 'BufNewFile'},
    config = function()
        require('mini.splitjoin').setup({
            mappings = {
                toggle = '<leader>sa'
            }
        })
    end
}
