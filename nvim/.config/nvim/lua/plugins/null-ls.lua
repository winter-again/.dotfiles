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
                'stylua',
                'black'
            },
            automatic_installation = false,
            handlers = {}
        })
        -- null-ls config
        -- local null_ls = require('null-ls')
        require('null-ls').setup({
            border = 'rounded',
            sources = {
                -- add anything Mason doesn't support
            }
        })
        vim.keymap.set('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>', {silent=true})
    end
}
