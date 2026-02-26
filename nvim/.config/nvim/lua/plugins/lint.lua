return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("lint").linters_by_ft = {
            javascript = { "eslint" },
            javascriptreact = { "eslint" },
            lua = { "selene" },
            markdown = { "markdownlint-cli2" },
            sh = { "shellcheck" },
            typescript = { "eslint" },
            typescriptreact = { "eslint" },
        }

        local lint_group = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = lint_group,
            callback = function()
                -- ignore command-not-found errors, e.g., for eslint when no config file
                -- see: https://github.com/mfussenegger/nvim-lint/issues/272
                -- and: https://github.com/mfussenegger/nvim-lint/issues/454
                require("lint").try_lint(nil, { ignore_errors = true })
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            require("lint").try_lint()
        end, { silent = true, desc = "Manually trigger nvim-lint" })
    end,
}
