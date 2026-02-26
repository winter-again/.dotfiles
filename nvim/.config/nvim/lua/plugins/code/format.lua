return {
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    lua = { 'stylua' },
                    -- trying ruff_lsp instead
                    -- python = { 'isort', 'black' },
                    go = { 'goimports', 'gofmt' },
                    html = { 'prettierd' },
                    css = { 'prettierd' },
                    javascript = { 'prettierd' },
                    javascriptreact = { 'prettierd' },
                    typescript = { 'prettierd' },
                    typescriptreact = { 'prettierd' },
                    -- disabling to let jsonls handle formatting
                    -- so we don't have to constantly set overrides in a .prettierrc.json
                    -- json = { 'prettierd' },
                    -- sql = { 'sqlfluff' },
                    -- 'injected' allows formatting of code fence blocks
                    -- could even have it in python to format sql inside of queries
                    -- see: https://github.com/stevearc/conform.nvim/blob/c36fc6492be27108395443a67bcbd2b3280f29c5/doc/advanced_topics.md
                    -- markdown = { 'injected' },
                },
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    return { timeout_ms = 500, lsp_fallback = true }
                end,
            })

            -- manually trigger formatting
            vim.keymap.set('n', '<leader><leader>fm', function()
                require('conform').format({ async = true, lsp_fallback = true })
            end, { silent = true, desc = 'Manually format buffer with conform.nvim' })

            -- user commands for toggling autoformatting on save
            vim.api.nvim_create_user_command('FormatDisable', function(args)
                if args.bang then
                    -- FormatDisable! will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {
                desc = 'Disable autoformat-on-save',
                bang = true,
            })
            vim.api.nvim_create_user_command('FormatEnable', function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {
                desc = 'Re-enable autoformat-on-save',
            })
        end,
    },
}
