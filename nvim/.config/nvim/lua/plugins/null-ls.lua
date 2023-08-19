return {
    'jay-babu/mason-null-ls.nvim',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
        'williamboman/mason.nvim',
        'jose-elias-alvarez/null-ls.nvim'
    },
    config = function()
        require('mason-null-ls').setup({
            ensure_installed = {
                'stylua'
            },
            automatic_installation = false,
            handlers = {}
        })
        require('null-ls').setup({
            sources = {
                -- anything Mason doesn't support
            }
        })
    end
}
