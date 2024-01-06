return {
    'winter-again/wezterm-config.nvim',
    -- dev = true,
    config = function()
        local wezterm_config = require('wezterm-config')
        local function bg_colorscheme(bg)
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

        local function bg_map(name, key)
            key = key or name
            if name == 'default' then
                vim.keymap.set('n', '<leader><leader>' .. key, function()
                    wezterm_config.set_wezterm_user_var('profile_background', name)
                end)
            else
                -- old:
                -- vim.keymap.set('n', '<leader><leader>' .. key, function()
                --     wezterm_config.set_wezterm_user_var('profile_background', 'bg_' .. key)
                -- end, { silent = true })

                -- set colorscheme and background together
                vim.keymap.set('n', '<leader><leader>' .. key, function()
                    bg_colorscheme('bg_' .. key)
                end)
            end
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
        bg_map('9')
    end,
}
