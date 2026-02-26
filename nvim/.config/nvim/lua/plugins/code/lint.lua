return {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('lint').linters_by_ft = {
            lua = { 'selene' },
            javascript = { 'eslint' },
            javascriptreact = { 'eslint' },
            typescript = { 'eslint' },
            typescriptreact = { 'eslint' },
            -- markdown = {}, -- disables default linting?
        }

        -- autocommand that triggers linting
        local lint_group = vim.api.nvim_create_augroup('Lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
            group = lint_group,
            callback = function()
                -- ignore command-not-found errors, e.g., for eslint when no config file
                -- see: https://github.com/mfussenegger/nvim-lint/issues/272
                -- and: https://github.com/mfussenegger/nvim-lint/issues/454
                require('lint').try_lint(nil, { ignore_errors = true })
            end,
        })
        -- manually trigger linting
        vim.keymap.set('n', '<leader><leader>l', function()
            require('lint').try_lint()
        end, { silent = true, desc = 'Manually trigger nvim-lint' })
    end,
}
