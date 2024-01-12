return {
    'winter-again/wezterm-config.nvim',
    -- dev = true,
    config = function()
        local wezterm_config = require('wezterm-config')
        local function set_bg_colorscheme(bg)
            local mapper = {
                ['tokyonight'] = { 'bg_1', 'bg_4', 'bg_6' },
                ['rose-pine'] = { 'bg_5', 'bg_6', 'bg_8', 'bg_9', 'bg_10' },
                ['catppuccin'] = { 'bg_3' },
                ['kanagawa'] = { 'bg_7' },
                ['gruvbox'] = { 'bg_2' },
            }
            for colorscheme, bgs in pairs(mapper) do
                for _, b in ipairs(bgs) do
                    if b == bg then
                        vim.cmd('colorscheme ' .. colorscheme)
                        break
                    end
                end
            end
            wezterm_config.set_wezterm_user_var('profile_background', bg)
            Transp()
        end

        local function bg_map(bg_profile, key, only_bg)
            -- only_bg = only_bg or true -- why doesn't this work as expected/before? I thought the truthiness worked out
            if only_bg == true then
                -- set just the bg
                vim.keymap.set('n', '<leader><leader>' .. key, function()
                    wezterm_config.set_wezterm_user_var('profile_background', bg_profile)
                end, { silent = true, desc = 'Set Wezterm background to ' .. bg_profile .. ' profile' })
            else
                -- set colorscheme and background together
                vim.keymap.set('n', '<leader><leader>' .. key, function()
                    set_bg_colorscheme(bg_profile)
                end, {
                    silent = true,
                    desc = 'Set Wezterm background to ' .. bg_profile .. ' profile + Neovim colorscheme',
                })
            end
        end

        bg_map('default', 'd', true)
        bg_map('bg_1', '1', false)
        bg_map('bg_2', '2', false)
        bg_map('bg_3', '3', false)
        bg_map('bg_4', '4', false)
        bg_map('bg_5', '5', false)
        bg_map('bg_6', '6', false)
        bg_map('bg_7', '7', false)
        bg_map('bg_8', '8', false)
        bg_map('bg_9', '9', false)
        bg_map('bg_10', '0', false)

        vim.keymap.set('n', '<leader><leader>f1', function()
            wezterm_config.set_wezterm_user_var('profile_font', 'font_1')
        end, { silent = true, desc = 'Set Wezterm font font_1' })
        vim.keymap.set('n', '<leader><leader>f2', function()
            wezterm_config.set_wezterm_user_var('profile_font', 'font_2')
        end, { silent = true, desc = 'Set Wezterm font font_2' })
        vim.keymap.set('n', '<leader><leader>f3', function()
            wezterm_config.set_wezterm_user_var('profile_font', 'font_3')
        end, { silent = true, desc = 'Set Wezterm font font_3' })
    end,
}
