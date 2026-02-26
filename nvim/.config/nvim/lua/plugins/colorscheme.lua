return {
    {
        'folke/tokyonight.nvim',
        lazy = false, -- ensure main colorscheme loaded on start up
        priority = 1000, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require('tokyonight').setup({
                style = 'night',
                styles = {
                    functions = { bold = true },
                    sidebars = 'dark',
                    floats = 'dark',
                },
                lualine_bold = true,
                on_colors = function(colors)
                    colors.border = colors.fg_dark
                end,
                on_highlights = function(highlights, colors)
                    highlights['WinBar'] = { bg = 'none', italic = true }
                    highlights['WinBarNC'] = { bg = 'none', italic = true }
                    -- highlights['Visual'] = { bg = colors.bg_visual, reverse = true }
                    highlights['LineNr'] = { fg = '#696d87' } -- line number color
                    highlights['CursorLineNr'] = { fg = colors.fg } -- cursor line number color
                    highlights['TelescopeSelection'] = { bg = colors.bg_visual }
                    -- swap undercurl for underdot
                    highlights['DiagnosticUnderlineError'] = { underdotted = true }
                    highlights['DiagnosticUnderlineWarn'] = { underdotted = true }
                    highlights['DiagnosticUnderlineInfo'] = { underdotted = true }
                    highlights['DiagnosticUnderlineHint'] = { underdotted = true }
                    highlights['@lsp.type.unresolvedReference'] = { underdotted = true }
                    highlights['SpellBad'] = { underdotted = true }
                    highlights['SpellCap'] = { underdotted = true }
                end,
            })
        end,
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 999, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require('kanagawa').setup({
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = 'none',
                            },
                        },
                        wave = {
                            ui = {
                                bg_visual = '#45475a',
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        WinSeparator = { fg = theme.ui.nontext },
                        -- Visual = { reverse = true },
                        WinBar = { bg = 'none', italic = true },
                        WinBarNC = { bg = 'none', italic = true },
                        DiagnosticUnderlineError = { underdotted = true },
                        DiagnosticUnderlineWarn = { underdotted = true },
                        DiagnosticUnderlineInfo = { underdotted = true },
                        DiagnosticUnderlineHint = { underdotted = true },
                        ['@lsp.type.unresolvedReference'] = { underdotted = true },
                    }
                end,
            })
        end,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 998, -- ensure colorscheme loaded before all other start up plugins
        lazy = false,
        config = function()
            require('catppuccin').setup({
                flavour = 'mocha',
                -- transparent_background = true, -- built-in transparency; doesn't suit all my needs
                custom_highlights = function(colors)
                    return {
                        TreesitterContext = { bg = colors.surface2 },
                        TreesitterContextLineNumber = { fg = colors.surface2, bg = 'none' },
                        WinSeparator = { fg = colors.overlay0 },
                        LineNr = { fg = colors.overlay0 },
                        -- Visual = { reverse = true },
                        WinBar = { fg = 'none', bg = 'none', italic = true },
                        WinBarNC = { bg = 'none', italic = true },
                        DiagnosticUnderlineError = { underdotted = true },
                        DiagnosticUnderlineWarn = { underdotted = true },
                        DiagnosticUnderlineInfo = { underdotted = true },
                        DiagnosticUnderlineHint = { underdotted = true },
                        ['@lsp.type.unresolvedReference'] = { underdotted = true },
                        RenameMatch = { link = 'Search' },
                        Pmenu = { bg = colors.crust },
                        TroubleNormal = { bg = 'none' },
                    }
                end,
                integrations = {
                    treesitter = true,
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = false,
                    },
                    lsp_saga = true,
                    lsp_trouble = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { 'italic' },
                            hints = { 'italic' },
                            warnings = { 'italic' },
                            information = { 'italic' },
                        },
                        underlines = {
                            errors = { 'underline' },
                            hints = { 'underline' },
                            warnings = { 'underline' },
                            information = { 'underline' },
                        },
                    },
                    treesitter_context = true,
                    which_key = true,
                },
            })
        end,
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        -- for local dev:
        -- name = 'rose-pine.nvim',
        -- dev = true,
        lazy = false,
        priority = 997, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require('rose-pine').setup({
                variant = 'main',
                styles = {
                    bold = true,
                    italic = true,
                    -- transparency = true,
                },
                highlight_groups = {
                    TreesitterContext = { bg = 'foam', blend = 10 },
                    -- Visual = { reverse = true },
                    WinBar = { bg = 'none', italic = true, inherit = false },
                    WinBarNC = { bg = 'none', italic = true, inherit = false },
                    WinSeparator = { fg = 'muted', bg = 'none' },
                    -- for transparency, otherwise bg remains in signcolumn
                    GitSignsAdd = { bg = 'none' },
                    GitSignsDelete = { bg = 'none' },
                    GitSignsChange = { bg = 'none' },
                    DiagnosticUnderlineError = { underdotted = true },
                    DiagnosticUnderlineWarn = { underdotted = true },
                    DiagnosticUnderlineInfo = { underdotted = true },
                    DiagnosticUnderlineHint = { underdotted = true },
                    ['@lsp.type.unresolvedReference'] = { underdotted = true },
                },
            })
            -- vim.api.nvim_set_hl(0, 'WinBarNC', { bg = 'none', force = true })
        end,
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 996,
        config = function()
            require('gruvbox').setup({
                invert_selection = true,
                overrides = {
                    WinSeparator = { bg = 'none' },
                    CursorLineNr = { bg = 'none' },
                    WinBar = { bg = 'none', italic = true },
                    WinBarNC = { bg = 'none', italic = true },
                },
                transparent_mode = true,
            })
        end,
    },
    {
        'winter-again/winter-again.nvim',
        dev = true,
    },
    {
        'nyngwang/nvimgelion',
        -- 'winter-again/nvimgelion',
        -- dev = true,
        config = function() end,
    },
    {
        'winter-again/seoul256.nvim',
        -- dev = true,
        branch = 'fix-indent-blankline',
    },
    {
        'savq/melange-nvim',
        lazy = false,
    },
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        config = function()
            local palette = require('nordic.colors')
            require('nordic').setup({
                override = {
                    WinSeparator = { fg = palette.white0, bg = 'none' },
                    -- Visual = { reverse = true },
                    GitSignsAdd = { bg = 'none' },
                    GitSignsDelete = { bg = 'none' },
                    GitSignsChange = { bg = 'none' },
                    FoldColumn = { bg = 'none' },
                },
            })
            require('nordic').load()
        end,
    },
    -- colorschemes that use contrasts and font variations to
    -- distinguish code over just colors
    {
        'mcchrish/zenbones.nvim',
        dependencies = { 'rktjmp/lush.nvim' },
    },
    {
        'rockerBOO/boo-colorscheme-nvim',
        config = function()
            require('boo-colorscheme').use({
                italic = true,
                theme = 'boo',
            })
        end,
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
    },
    {
        'nyoom-engineering/oxocarbon.nvim',
        lazy = false,
    },
}
