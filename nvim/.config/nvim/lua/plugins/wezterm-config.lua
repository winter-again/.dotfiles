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
        bg_map('1') -- tokyonight, catppuccin
        bg_map('2') -- gruvbox
        bg_map('3') -- tokyonight, kanagawa, catppuccin
        bg_map('4') -- tokyonight, kanagawa
        bg_map('5') -- tokyonight, kanagawa, gruvbox
        bg_map('6') -- rose-pine
        bg_map('7') -- rose-pine
        bg_map('8') -- gruvbox, rose-pine
        bg_map('9') -- tokyonight, catppuccin, kanagawa
    end,
}
