return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            columns = { "icon" },
            use_default_keymaps = false,
            keymaps = {
                ["<CR>"] = "actions.select",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["g."] = "actions.toggle_hidden",
            },
            view_options = {
                show_hidden = true,
            },
            float = {
                max_width = 50,
                max_height = 600,
                win_options = { winblend = 30 },
                override = function(conf)
                    conf.relative = "editor"
                    conf.row = 0
                    conf.col = 159
                    return conf
                end,
            },
        })
        vim.keymap.set("n", "<leader>pv", require("oil").toggle_float, { desc = "Open Oil in floating window" })
        -- vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory of current file in Oil" })
        vim.keymap.set("n", "<leader>ph", "<cmd>split | Oil<CR>", { desc = "Open Oil in split" })
    end,
}
