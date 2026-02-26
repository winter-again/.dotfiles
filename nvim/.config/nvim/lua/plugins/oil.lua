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
                padding = 0,
                -- max_width = 50,
                max_height = 16,
                border = "none",
                -- win_options = { winblend = 20 },
                delete_to_trash = true,
                preview_split = "right",
                override = function(conf)
                    conf.relative = "editor"
                    conf.row = 200
                    conf.col = 0

                    return conf
                end,
            },
        })

        local map = require("winteragain.globals").map

        map("n", "<leader>pv", require("oil").toggle_float, nil, "Open Oil in floating window")
        -- vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory of current file in Oil" })
        -- map("n", "<leader>ph", "<cmd>split | Oil<CR>", nil, "Open Oil in split")

        -- auto open preview on cursor hover
        local au_group = vim.api.nvim_create_augroup("WinterAgain", { clear = false })
        vim.api.nvim_create_autocmd("User", {
            pattern = "OilEnter",
            group = au_group,
            callback = vim.schedule_wrap(function(args)
                local oil = require("oil")
                if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
                    oil.open_preview()
                end
            end),
        })
    end,
}
