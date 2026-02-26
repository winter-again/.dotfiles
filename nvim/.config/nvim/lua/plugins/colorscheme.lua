return {
    {
        'folke/tokyonight.nvim',
        lazy = false, -- ensure main colorscheme loaded on start up
        priority = 1000, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require('tokyonight').setup({
                style = 'night',
                styles = {
                    sidebars = 'dark',
                    floats = 'dark',
                },
                lualine_bold = true,
                on_colors = function(colors)
                    colors.border = colors.fg_dark
                end,
                -- from here: https://github.com/folke/tokyonight.nvim/issues/289
                -- doing this allows my cursorline to not get overriden when cursor is in a code block
                on_highlights = function(highlights, colors)
                    -- using this keeps cursorline highlight from getting overriden in markdown code blocks
                    -- highlights['@text.literal.markdown'] = { link = '@punctuation.delimiter.markdown' }
                    highlights['Visual'] = { bg = colors.bg_visual, reverse = true }
                    highlights['LineNr'] = { fg = '#696d87' } -- line number color
                    highlights['CursorLineNr'] = { fg = colors.fg } -- cursor line number color
                    highlights['TelescopeSelection'] = { bg = colors.bg_visual }
                end,
            })
        end,
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
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
                        Visual = { reverse = true },
                    }
                end,
            })
        end,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        config = function()
            require('catppuccin').setup({
                flavour = 'mocha',
                custom_highlights = function(colors)
                    return {
                        TreesitterContext = { bg = colors.surface2 },
                        WinSeparator = { fg = colors.surface2 },
                        LineNr = { fg = colors.surface2 },
                        Visual = { reverse = true },
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
        lazy = false,
        config = function()
            require('rose-pine').setup({
                variant = 'moon',
                highlight_groups = {
                    TreesitterContext = { bg = 'foam', blend = 10 },
                    -- for transparency, otherwise bg remains in signcolumn
                    GitSignsAdd = { bg = 'none' },
                    GitSignsDelete = { bg = 'none' },
                    GitSignsChange = { bg = 'none' },
                    Visual = { reverse = true },
                },
            })
        end,
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        config = function()
            require('gruvbox').setup({
                invert_selection = true,
                overrides = {
                    WinSeparator = { bg = 'none' },
                    CursorLineNr = { bg = 'none' },
                },
                transparent_mode = true,
            })
        end,
    },
    -- has a decent light theme
    {
        'savq/melange-nvim',
        lazy = false,
    },
    {
        'shaunsingh/nord.nvim',
        config = function()
            vim.g.nord_contrast = true
        end,
    },
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        config = function()
            local palette = require('nordic.colors')
            require('nordic').setup({
                override = {
                    WinSeparator = { fg = palette.white0, bg = 'none' },
                    Visual = { reverse = true },
                    GitSignsAdd = { bg = 'none' },
                    GitSignsDelete = { bg = 'none' },
                    GitSignsChange = { bg = 'none' },
                },
            })
            require('nordic').load()
        end,
    },
    -- have issues with indent markers
    {
        'nyngwang/nvimgelion',
        config = function() end,
    },
    {
        'craftzdog/solarized-osaka.nvim',
        lazy = false,
        config = function()
            require('solarized-osaka').setup({
                transparent = true,
                lualine_bold = true,
            })
        end,
    },
    -- collection of colorschemes that uses contrasts and font variations to
    -- distinguish code
    {
        'mcchrish/zenbones.nvim',
        dependencies = { 'rktjmp/lush.nvim' },
    },
}
