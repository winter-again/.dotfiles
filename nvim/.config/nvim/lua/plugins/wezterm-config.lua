return {
    'winter-again/wezterm-config.nvim',
    -- dev = true,
    config = function()
        vim.keymap.set(
            'n',
            '<leader><leader>0',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "default")<CR>'
        )
        vim.keymap.set(
            'n',
            '<leader><leader>1',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_1")<CR>'
        )
        vim.keymap.set(
            'n',
            '<leader><leader>2',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_2")<CR>'
        )
        vim.keymap.set(
            'n',
            '<leader><leader>3',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_3")<CR>'
        )
        vim.keymap.set(
            'n',
            '<leader><leader>4',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_4")<CR>'
        )
        vim.keymap.set(
            'n',
            '<leader><leader>5',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_5")<CR>'
        )

        vim.keymap.set(
            'n',
            '<leader><leader>g',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_colors", "colors_1")<CR>'
        )
        vim.keymap.set(
            'n',
            '<leader><leader>b',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_colors", "colors_2")<CR>'
        )
    end,
}
