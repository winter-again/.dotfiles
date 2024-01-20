return {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
        local alpha = require('alpha')
        local dashboard = require('alpha.themes.dashboard')
        local lazy_stats = require('lazy').stats()
        local devicons = require('nvim-web-devicons')

        local function header()
            local date_time = os.date('%Y-%m-%d (%a) %I:%M %p')
            local version = vim.version()
            local version_info = devicons.get_icon_by_filetype('vim')
                .. ' v'
                .. version.major
                .. '.'
                .. version.minor
                .. '.'
                .. version.patch
            local plugins_tot = lazy_stats.count -- total number of plugins

            -- local Checker = require('lazy.manage.checker')
            -- local updates = 0
            -- if require('lazy.status').has_updates() == true then
            --     updates = #Checker.updated
            -- end

            return '󱛡 ' .. date_time .. ' | ' .. version_info .. ' | ' .. ' ' .. plugins_tot
            -- .. ' plugins ['
            -- .. updates
            -- .. ']'
        end

        -- local function buttons()
        --     return {
        --         dashboard.button('SPC pv', '󰙅  Toggle file tree'),
        --         -- dashboard.button('SPC fr', '  Recent files'),
        --         dashboard.button('SPC pr', '  Restore last local session'),
        --         -- dashboard.button('SPC fp', '  Find session'),
        --         dashboard.button('SPC ff', '  Find file'),
        --         dashboard.button('SPC fs', '  Find string in cwd'),
        --     }
        -- end

        dashboard.section.header.val = header()
        -- dashboard.section.buttons.val = buttons()

        dashboard.config.layout = {
            { type = 'padding', val = 3 },
            dashboard.section.header,
            { type = 'padding', val = 5 },
            -- dashboard.section.buttons,
        }
        alpha.setup(dashboard.opts)
    end,
}
