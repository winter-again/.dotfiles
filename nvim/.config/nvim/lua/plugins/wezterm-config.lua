return {
    'winter-again/wezterm-config.nvim',
    -- dev = true,
    config = function()
        local wezterm_config = require('wezterm-config')
        -- NOTE: changes to profile_data seem to get picked up like hot reloading
        -- not sure how reliable
        wezterm_config.setup({
            append_wezterm_to_rtp = true,
        })
        local profile_data = require('profile_data')
        local reload = require('plenary.reload').reload_module

        local map = function(mode, lhs, rhs, opts, desc)
            opts = opts or {}
            opts.desc = desc
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        local opts = { silent = true }

        -- not sure how well this works
        -- map('n', '<leader><leader>r', function()
        --     reload('profile_data', false)
        -- end)

        map('n', '<leader><leader>d', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.default.background)
        end, opts, '')
        map('n', '<leader><leader>1', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_1.background)
        end, opts, '')
        map('n', '<leader><leader>2', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_2.background)
        end, opts, '')
        map('n', '<leader><leader>3', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_3.background)
        end, opts, '')
        map('n', '<leader><leader>4', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_4.background)
        end, opts, '')
        map('n', '<leader><leader>5', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_5.background)
        end, opts, '')
        map('n', '<leader><leader>6', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_6.background)
        end, opts, '')
        map('n', '<leader><leader>7', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_7.background)
        end, opts, '')
        map('n', '<leader><leader>8', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_8.background)
        end, opts, '')
        map('n', '<leader><leader>9', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_9.background)
        end, opts, '')
        map('n', '<leader><leader>0', function()
            wezterm_config.set_wezterm_user_var('background', profile_data.background.bg_10.background)
        end, opts, '')

        vim.api.nvim_create_user_command('Bg', function(new_opt)
            local bg_choice = tostring(new_opt.fargs[1])
            local bg_choice_data
            for _, v in pairs(profile_data.background) do
                if v.alias == bg_choice then
                    bg_choice_data = v.background
                end
            end
            wezterm_config.set_wezterm_user_var('background', bg_choice_data)
        end, {
            nargs = 1,
            -- TODO: figure out how to get the autocomplete working with new setup
            complete = function(ArgLead, CmdLine, CursorPos)
                local bg_names = {}
                for _, v in pairs(profile_data.background) do
                    table.insert(bg_names, v.alias)
                end
                table.sort(bg_names)
                return bg_names
            end,
            desc = 'Set Wezterm background',
        })
    end,
}
