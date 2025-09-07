return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    even = "VimEnter",
    config = function()
        local permission_hlgroups = {
            ["-"] = "Comment",
            ["r"] = "DiagnosticSignWarn",
            ["w"] = "DiagnosticSignError",
            ["x"] = "DiagnosticSignOk",
        }
        require("oil").setup({
            default_file_explorer = false,
            delete_to_trash = true,
            columns = {
                {
                    "permissions",
                    highlight = function(permission_str)
                        local hls = {}
                        for i = 1, #permission_str do
                            local char = permission_str:sub(i, i)
                            table.insert(hls, { permission_hlgroups[char], i - 1, i })
                        end
                        return hls
                    end,
                },
                -- custom hl groups
                { "size", highlight = "OilSize" },
                { "mtime", highlight = "OilModTime" },
                { "icon", add_padding = false },
            },
            constrain_cursor = "name",
            use_default_keymaps = false,
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<CR>"] = "actions.select",
                ["-"] = { "actions.parent", mode = "n" },
                ["_"] = { "actions.open_cwd", mode = "n" },
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = { "actions.close", mode = "n" },
            },
            view_options = {
                show_hidden = true,
            },
            float = {
                padding = 0,
                max_height = 16,
                border = "solid",
                -- win_options = { winblend = 20 },
                preview_split = "right",
                override = function(conf)
                    conf.relative = "editor"
                    conf.row = 200
                    conf.col = 0
                    return conf
                end,
            },
            preview_win = {
                disable_preview = function(filename)
                    local no_prev = {
                        ".png",
                        ".jpg",
                        ".jpeg",
                    }
                    local ext = filename:match("^.+(%..+)$")
                    for _, targ in ipairs(no_prev) do
                        if ext == targ then
                            return true
                        end
                    end
                    return false
                end,
            },
        })

        local map = require("winter-again.globals").map

        map("n", "<leader>e", require("oil").toggle_float, { silent = true }, "Toggle Oil")

        -- BUG: can't move, can only copy if preview open
        -- auto open preview on cursor hover
        -- local au_group = vim.api.nvim_create_augroup("winter.again", { clear = false })
        -- vim.api.nvim_create_autocmd("User", {
        --     pattern = "OilEnter",
        --     group = au_group,
        --     callback = vim.schedule_wrap(function(args)
        --         local oil = require("oil")
        --         if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
        --             oil.open_preview()
        --         end
        --     end),
        -- })
    end,
}
