return {
    'winter-again/wezterm-config.nvim',
    dev = true,
    config = function()
        vim.keymap.set('n', '<leader><leader>q', ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_1")<CR>')
        vim.keymap.set('n', '<leader><leader>w', ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_3")<CR>')
        vim.keymap.set(
            'n', '<leader><leader>g',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_colors", "colors_1")<CR>'
        )
        vim.keymap.set(
            'n', '<leader><leader>b',
            ':lua require("wezterm-config").set_wezterm_user_var("profile_colors", "colors_2")<CR>'
        )

        vim.keymap.set('n', '<leader><leader>e', ':lua require("wezterm-config").set_wezterm_user_var("font_size", "20")<CR>')
        vim.keymap.set('n', '<leader><leader>r', ':lua require("wezterm-config").set_wezterm_user_var("font_size", ".99")<CR>')
        vim.keymap.set('n', '<leader><leader>t', ':lua require("wezterm-config").set_wezterm_user_var("hide_tab_bar_if_only_one_tab", "true")<CR>')
        vim.keymap.set('n', '<leader><leader>y', ':lua require("wezterm-config").set_wezterm_user_var("hide_tab_bar_if_only_one_tab", "false")<CR>')

        vim.keymap.set('n', '<leader><leader>u', ':lua require("wezterm-config").set_wezterm_user_var("hide_tab_bar_if_only_one_tab", "foo")<CR>')

        vim.keymap.set('n', '<leader><leader>i', ':lua require("wezterm-config").set_wezterm_user_var("color_scheme", "tokyonight_night")<CR>')
        vim.keymap.set('n', '<leader><leader>a', ':lua require("wezterm-config").set_wezterm_user_var("color_scheme", "kanagawabones")<CR>')
        vim.keymap.set('n', '<leader><leader>s', ':lua require("wezterm-config").set_wezterm_user_var("color_scheme", "Kasugano (terminal.sexy)")<CR>')

    end,
}
