return {
    {
        'folke/tokyonight.nvim',
        lazy = false, -- ensure main colorscheme loaded on start up
        priority = 1000, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require('tokyonight').setup({
                style = 'night',
                on_colors = function(colors)
                    colors.border = '#696d87' -- override window border color
                end,
                -- from here: https://github.com/folke/tokyonight.nvim/issues/289
                -- doing this allows my cursorline to not get overriden when cursor is in a code block
                on_highlights = function(highlights, colors)
                    -- using this keeps cursorline highlight from getting overriden in markdown code blocks
                    highlights['@text.literal.markdown'] = {link = '@punctuation.delimiter.markdown'}
                    highlights['FidgetTask'] = {fg=colors.fg} -- override for fidget plugin
                end
            })
            vim.cmd('colorscheme tokyonight') -- set default colorscheme after configuring
        end
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
                                bg_gutter = 'none'
                            }
                        }
                    }
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        WinSeparator = {fg = theme.ui.nontext}
                    }
                end,
            })
        end
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
                        TreesitterContext = {bg = colors.surface2},
                        WinSeparator = {fg = colors.surface2}
                    }
                end,
                -- overrides for stark black bg
                -- color_overrides = {
                --     mocha = {
                --         base = '#000000',
                --         mantle = '#000000',
                --         crust = '#000000'
                --     }
                -- },
                integrations = {
                    treesitter = true,
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = false
                    },
                    lsp_saga = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = {'italic'},
                            hints = {'italic'},
                            warnings = {'italic'},
                            information = {'italic'}
                        },
                        underlines = {
                            errors = {'underline'},
                            hints = {'underline'},
                            warnings = {'underline'},
                            information = {'underline'}
                        }
                    },
                    treesitter_context = true,
                    which_key = true
                }
            })
        end
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        config = function()
            require('rose-pine').setup({
                variant = 'moon',
                highlight_groups = {
                    TreesitterContext = {bg = 'foam', blend = 10},
                }
            })
        end
    }
}
