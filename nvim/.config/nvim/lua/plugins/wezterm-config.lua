return {
    "winter-again/wezterm-config.nvim",
    -- dev = true,
    config = function()
        local wezterm_config = require("wezterm-config")
        -- NOTE: changes to profile_data should be hot-reloaded somehow?
        -- prob better to just have some function that can reload the specific Lua
        -- data file
        wezterm_config.setup({
            append_wezterm_to_rtp = true,
        })
        local profile_data = require("profile_data")

        local function map(mode, lhs, rhs, opts, desc)
            opts = opts or {}
            opts.desc = desc
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        local opts = { silent = true }

        -- NOTE: doesn't seem to work
        -- local reload = require('plenary.reload').reload_module
        -- map('n', '<leader><leader>r', function()
        --     reload('profile_data', false)
        -- end, opts, '')

        -- map("n", "<leader><leader>d", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.default.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>1", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_1.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>2", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_2.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>3", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_3.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>4", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_4.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>5", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_5.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>6", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_6.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>7", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_7.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>8", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_8.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>9", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_9.background)
        -- end, opts, "")
        -- map("n", "<leader><leader>0", function()
        --     wezterm_config.set_wezterm_user_var("background", profile_data.background.bg_10.background)
        -- end, opts, "")

        vim.api.nvim_create_user_command("Bliss", function(args)
            local sub_cmd = args.fargs[1]
            local arg = args.fargs[2]

            local choice
            -- NOTE: restricted choices
            if sub_cmd == "background" then
                for _, val in pairs(profile_data.background) do
                    if val.alias == arg then
                        choice = val.background
                    end
                end
                if choice ~= nil then
                    wezterm_config.set_wezterm_user_var("background", choice)
                end
            elseif sub_cmd == "font" then
                for key, val in pairs(profile_data.font) do
                    if key == arg then
                        choice = val
                    end
                end
                if choice ~= nil then
                    wezterm_config.set_wezterm_user_var("font", choice.font)
                    wezterm_config.set_wezterm_user_var("font_size", choice.font_size)
                end
            end
        end, {
            nargs = "+", -- '+' = args must be supplied but any number
            -- arg_lead = the leading portion of the arg currently being completed on
            -- cmd_line = the entire command line
            -- cursor_pos = the cursor position in it (byte index)
            complete = function(arg_lead, cmd_line, cursor_pos)
                local choices = {}
                local cmd = cmd_line:sub(1, cursor_pos):match("Bliss%s*(.*)$"):gsub("%s+", "")
                if cmd == "background" then
                    for _, v in pairs(profile_data.background) do
                        table.insert(choices, v.alias)
                    end
                elseif cmd == "font" then
                    for k, _ in pairs(profile_data.font) do
                        table.insert(choices, k)
                    end
                else
                    choices = { "background", "font" }
                end
                return choices
            end,
            desc = "Send Wezterm overrides from presets",
        })

        -- vim.api.nvim_create_user_command('Bg', function(args)
        --     local bg_choice = args.fargs[1]
        --     local bg_choice_data
        --     for _, v in pairs(profile_data.background) do
        --         if v.alias == bg_choice then
        --             bg_choice_data = v.background
        --         end
        --     end
        --     wezterm_config.set_wezterm_user_var('background', bg_choice_data)
        -- end, {
        --     nargs = 1,
        --     complete = function(ArgLead, CmdLine, CursorPos)
        --         local bg_names = {}
        --         for _, v in pairs(profile_data.background) do
        --             table.insert(bg_names, v.alias)
        --         end
        --         table.sort(bg_names)
        --         return bg_names
        --     end,
        --     desc = 'Set Wezterm background',
        -- })
    end,
}
