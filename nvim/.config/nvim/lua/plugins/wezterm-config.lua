return {
    'winter-again/wezterm-config.nvim',
    -- dev = true,
    config = function()
        local function bg_map(name, key)
            key = key or name
            local bg_call
            if name == 'default' then
                bg_call = ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "default")<CR>'
            else
                bg_call = string.format(
                    ':lua require("wezterm-config").set_wezterm_user_var("profile_background", "bg_%s")<CR>',
                    name
                )
            end
            vim.keymap.set('n', '<leader><leader>' .. key, bg_call, { silent = true })
        end

        bg_map('default', '0')
        bg_map('1')
        bg_map('2')
        bg_map('3')
        bg_map('4')
        bg_map('5')
        bg_map('6')
        bg_map('7')
        bg_map('8')

        -- vim.keymap.set(
        --     'n',
        --     '<leader><leader>g',
        --     ':lua require("wezterm-config").set_wezterm_user_var("profile_colors", "colors_1")<CR>'
        -- )
        -- vim.keymap.set(
        --     'n',
        --     '<leader><leader>b',
        --     ':lua require("wezterm-config").set_wezterm_user_var("profile_colors", "colors_2")<CR>'
        -- )
    end,
}
