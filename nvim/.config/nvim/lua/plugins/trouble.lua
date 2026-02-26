return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = { "<leader>tt" },
        config = function()
            require("trouble").setup({
                open_no_results = true, -- open even when no results
                modes = {
                    diagnostics = {
                        win = { position = "bottom" },
                        -- preview = {
                        --     type = "split",
                        --     relative = "win",
                        --     position = "right",
                        --     size = 0.5,
                        -- },
                    },
                    symbols = {
                        win = { position = "right", size = 0.25 },
                        preview = {
                            type = "split",
                            relative = "win",
                            position = "bottom",
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
                "<leader>tb",
                "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>",
                { silent = true, desc = "Toggle Trouble buffer diagnostics" }
            )
            vim.keymap.set(
                "n",
                "<leader>ts",
                "<cmd>Trouble symbols toggle<CR>",
                { silent = true, desc = "Toggle Trouble symbols" }
            )
            vim.keymap.set(
                "n",
                "<leader>tr",
                "<cmd>Trouble lsp toggle focus=false<CR>",
                { silent = true, desc = "Toggle Trouble LSP defns and references" }
            )
            vim.keymap.set(
                "n",
                "<leader>tl",
                "<cmd>Trouble qflist toggle focus=false<CR>",
                { silent = true, desc = "Toggle Trouble qflist" }
            )
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        enabled = false,
    },
}
