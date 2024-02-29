return {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
        local alpha = require('alpha')
        local dashboard = require('alpha.themes.dashboard')
        local function header()
            local version = vim.version()
            local version_info = string.format(
                ' v%s.%s.%s-%s+%s',
                version.major,
                version.minor,
                version.patch,
                version.prerelease,
                version.build
            )
            return { version_info }
        end
        dashboard.section.header.val = header()
        dashboard.config.layout = {
            { type = 'padding', val = 3 },
            dashboard.section.header,
            { type = 'padding', val = 1 },
            dashboard.section.footer,
        }
        alpha.setup(dashboard.opts)

        -- print lazy.nvim stats to alpha buffer
        vim.api.nvim_create_autocmd('User', {
            group = vim.api.nvim_create_augroup('WinterAgain', { clear = false }),
            callback = function()
                local stats = require('lazy').stats()
                local ms = math.floor(stats.startuptime * 100) / 100
                dashboard.section.footer.val =
                    string.format(' Loaded %d / %d plugins in %.3f ms', stats.loaded, stats.count, ms)
                vim.cmd([[AlphaRedraw]])
            end,
        })
    end,
}
