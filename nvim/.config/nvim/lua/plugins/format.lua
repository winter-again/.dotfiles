return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        config = function()
            require("conform").setup({
                -- NOTE: conform can find local formatters like prettier installed as dev dep
                formatters_by_ft = {
                    css = { "prettierd", "prettier", stop_after_reset = true },
                    go = { "goimports", "gofmt" }, -- sequential
                    html = { "prettierd", "prettier", stop_after_reset = true },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    javascriptreact = { "prettierd", "prettier", stop_after_reset = true },
                    just = { "just" },
                    lua = { "stylua" },
                    python = {
                        "ruff_organize_imports",
                        "ruff_format",
                        -- lsp_format = "fallback"
                    },
                    rust = {
                        "rustfmt",
                        -- lsp_format = "fallback"
                    },
                    typescript = { "prettierd", "prettier", stop_after_reset = true },
                    typescriptreact = { "prettierd", "prettier", stop_after_reset = true },
                    -- 'injected' allows formatting of code fence blocks
                    -- or in python to format sql inside of queries
                    -- see: https://github.com/stevearc/conform.nvim/blob/c36fc6492be27108395443a67bcbd2b3280f29c5/doc/advanced_topics.md
                    -- markdown = { "injected" },
                },
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end

                    return { timeout_ms = 500, lsp_fallback = false }
                end,
            })

            vim.keymap.set("n", "<leader><leader>f", function()
                require("conform").format({ async = true, lsp_fallback = false })
            end, { silent = true, desc = "Manually format buffer with conform.nvim" })

            -- user commands for toggling autoformatting on save
            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    -- FormatDisable! will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {
                desc = "Disable autoformat-on-save",
                bang = true,
            })
            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {
                desc = "Re-enable autoformat-on-save",
            })
        end,
    },
}
