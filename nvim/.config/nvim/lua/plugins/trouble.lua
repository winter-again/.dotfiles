return {
    {
        "folke/trouble.nvim",
        enabled = false,
        keys = { "<leader>tt", "<leader>ts" },
        config = function()
            require("trouble").setup({
                open_no_results = true, -- open even when no results
                modes = {
                    diagnostics = {
                        win = { position = "bottom" },
                    },
                    symbols = {
                        win = { position = "bottom" },
                        preview = {
                            type = "split",
                            relative = "win",
                            position = "right",
                            size = 0.5,
                        },
                    },
                    lsp_base = {
                        win = { position = "bottom" },
                        params = {
                            include_current = false,
                        },
                    },
                    qflist = {
                        win = { position = "bottom" },
                        preview = {
                            type = "split",
                            relative = "win",
                            position = "right",
                            size = 0.5,
                        },
                    },
                },
            })
            vim.keymap.set(
                "n",
                "<leader>tt",
                "<cmd>Trouble diagnostics toggle focus=false<CR>",
                { silent = true, desc = "Toggle Trouble diagnostics" }
            )
            vim.keymap.set(
                "n",
                "<leader>tl",
                "<cmd>Trouble qflist toggle focus=false<CR>",
                { silent = true, desc = "Toggle Trouble qflist" }
            )
            vim.keymap.set(
                "n",
                "<leader>ts",
                "<cmd>Trouble symbols toggle<CR>",
                { silent = true, desc = "Toggle Trouble symbols" }
            )
            vim.keymap.set(
                "n",
                "<leader>td",
                "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>",
                { silent = true, desc = "Toggle Trouble buffer diagnostics" }
            )
        end,
    },
}
