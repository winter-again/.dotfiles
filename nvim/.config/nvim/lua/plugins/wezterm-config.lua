return {
    'winter-again/wezterm-config.nvim',
    -- dev = true,
    config = function()
        local wezterm_config = require('wezterm-config')
        local function set_bg_colorscheme(bg)
            local mapper = {
                ['catppuccin'] = { 'bg_3' },
                ['gruvbox'] = { 'bg_2' },
                ['kanagawa'] = { 'bg_9' },
                ['rose-pine'] = { 'bg_6', 'bg_7', 'bg_8' },
                ['tokyonight'] = { 'bg_1', 'bg_4', 'bg_5' },
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
            -- only_bg = only_bg or true
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

        bg_map('default', '0', true)
        bg_map('bg_1', '1', false)
        bg_map('bg_2', '2', false)
        bg_map('bg_3', '3', true)
        bg_map('bg_4', '4', false)
        bg_map('bg_5', '5', false)
        bg_map('bg_6', '6', false)
        bg_map('bg_7', '7', false)
        bg_map('bg_8', '8', false)
        bg_map('bg_9', '9', false)

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
