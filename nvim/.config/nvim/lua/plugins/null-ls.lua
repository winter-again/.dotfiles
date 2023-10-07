return {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'williamboman/mason.nvim',
        'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
        require('mason-null-ls').setup({
            ensure_installed = {
                'stylua',
                'black',
            },
            automatic_installation = false,
            handlers = {},
        })
        -- null-ls config
        -- local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
        require('null-ls').setup({
            border = 'rounded',
            sources = {
                -- add anything Mason doesn't support
            },
            -- on_attach = function(client, bufnr)
            --     if client.supports_method('textDocument/formatting') then
            --         vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            --         vim.api.nvim_create_autocmd('BufWritePre', {
            --             group = augroup,
            --             buffer = bufnr,
            --             callback = function()
            --                 vim.lsp.buf.format({async = false})
            --             end
            --         })
            --     end
            -- end
        })
        vim.keymap.set('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>', { silent = true })
    end,
}
