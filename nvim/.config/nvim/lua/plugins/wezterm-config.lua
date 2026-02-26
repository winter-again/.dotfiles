return {
    'winter-again/wezterm-config.nvim',
    dev = true,
    config = function()
        local wezterm_config = require('wezterm-config')
        wezterm_config.setup({
            append_wezterm_to_rtp = true,
        })
        local profile_data = require('profile_data')

        local opts = { silent = true }
        -- TESTING: new plugin design; looks good so far
        Map('n', '<leader><leader>d', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.default)
        end, opts, '')
        Map('n', '<leader><leader>1', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_1)
        end, opts, '')
        Map('n', '<leader><leader>2', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_2)
        end, opts, '')
        Map('n', '<leader><leader>3', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_3)
        end, opts, '')
        Map('n', '<leader><leader>4', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_4)
        end, opts, '')
        Map('n', '<leader><leader>5', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_5)
        end, opts, '')
        Map('n', '<leader><leader>6', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_6)
        end, opts, '')
        Map('n', '<leader><leader>7', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_7)
        end, opts, '')
        Map('n', '<leader><leader>8', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_8)
        end, opts, '')
        Map('n', '<leader><leader>9', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_9)
        end, opts, '')
        Map('n', '<leader><leader>0', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_10)
        end, opts, '')

        -- vim.api.nvim_create_user_command('Bg', function(opts)
        --     local bg_profile = tostring(opts.fargs[1])
        --     wezterm_config.set_wezterm_user_var('profile_background', bg_profile)
        -- end, {
        --     nargs = 1,
        --     complete = function(ArgLead, CmdLine, CursorPos)
        --         local bg_names = {}
        --         for name, _ in pairs(profile_data.background) do
        --             table.insert(bg_names, name)
        --         end
        --         table.sort(bg_names)
        --         return bg_names
        --     end,
        --     desc = 'Set Wezterm background',
        -- })

        -- set bg and colorscheme according to some mapping
        -- local function set_bg_colorscheme(bg)
        --     local mapper = {
        --         ['tokyonight'] = { 'bg_1', 'bg_4' },
        --         ['rose-pine'] = { 'bg_5', 'bg_5_1', 'bg_6', 'bg_7', 'bg_7_1', 'bg_9', 'bg_10', 'bg_10_1' },
        --         ['catppuccin'] = { 'bg_3', 'bg_11' },
        --         ['kanagawa'] = { 'bg_8' },
        --         ['gruvbox'] = { 'bg_2' },
        --     }
        --     for colorscheme, bgs in pairs(mapper) do
        --         for _, b in ipairs(bgs) do
        --             if b == bg then
        --                 vim.cmd('colorscheme ' .. colorscheme)
        --                 break
        --             end
        --         end
        --     end
        --     wezterm_config.set_wezterm_user_var('profile_background', bg)
        --     Transp()
        -- end

        -- local function bg_map(bg_profile, key, only_bg)
        --     -- only_bg = only_bg or true -- why doesn't this work as expected/before? I thought the truthiness worked out
        --     if only_bg == true then
        --         -- set just the bg
        --         vim.keymap.set('n', '<leader><leader>' .. key, function()
        --             wezterm_config.set_wezterm_user_var('profile_background', bg_profile)
        --         end, { silent = true, desc = 'Set Wezterm background to ' .. bg_profile .. ' profile' })
        --     else
        --         -- set colorscheme and background together
        --         vim.keymap.set('n', '<leader><leader>' .. key, function()
        --             set_bg_colorscheme(bg_profile)
        --         end, {
        --             silent = true,
        --             desc = 'Set Wezterm background to ' .. bg_profile .. ' profile + Neovim colorscheme',
        --         })
        --     end
        -- end
        --
        -- bg_map('default', 'd', true)
        -- bg_map('bg_1', '1', false)
        -- bg_map('bg_2', '2', false)
        -- bg_map('bg_3', '3', false)
        -- bg_map('bg_4', '4', false)
        -- bg_map('bg_5', '5', false)
        -- bg_map('bg_6', '6', false)
        -- bg_map('bg_7', '7', false)
        -- bg_map('bg_8', '8', false)
        -- bg_map('bg_9', '9', false)
        -- bg_map('bg_10', '0', false)

        -- shouldn't work because the font setting func. is no longer in profile_data
        -- vim.keymap.set('n', '<leader><leader>f1', function()
        --     wezterm_config.set_wezterm_user_var('profile_font', 'font_1')
        -- end, { silent = true, desc = 'Set Wezterm font font_1' })
        -- vim.keymap.set('n', '<leader><leader>f2', function()
        --     wezterm_config.set_wezterm_user_var('profile_font', 'font_2')
        -- end, { silent = true, desc = 'Set Wezterm font font_2' })
        -- vim.keymap.set('n', '<leader><leader>f3', function()
        --     wezterm_config.set_wezterm_user_var('profile_font', 'font_3')
        -- end, { silent = true, desc = 'Set Wezterm font font_3' })
    end,
}
