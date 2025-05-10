return {
    {
        "winter-again/winter-again.nvim",
        lazy = false,
        priority = 1001,
        dev = true,
        config = function()
            require("winter-again").setup({
                saturation = 0,
                brightness = 0,
                -- transparent = false,
                -- text_styles = {
                --     booleans = { italic = false },
                -- },
                hl_overrides = function(highlights, colors)
                    highlights["Visual"] = { bg = colors.cursor_line }
                    highlights["QuickFixLine"] = { fg = colors.purple, bold = true }
                    highlights["@markup.list.checked"] = { strikethrough = true }
                    highlights["RenderMarkdownChecked"] = { strikethrough = false }
                end,
            })
        end,
    },
    {
        "ramojus/mellifluous.nvim",
        lazy = false,
        priority = 995,
        config = function()
            require("mellifluous").setup({
                -- mellifluous, alduin, mountain, and kanagawa_dragon are ok
                colorset = "mountain",
                mellifluous = {
                    neutral = true,
                    color_overrides = {
                        dark = {
                            fg = function(bg)
                                return bg:darkened(2)
                            end,
                        },
                    },
                },
                styles = {
                    main_keywords = { bold = true },
                    functions = { bold = true },
                    types = { bold = false, italic = true },
                    comments = { italic = true },
                    markup = { headings = { bold = true } },
                },
                highlight_overrides = {
                    dark = function(highlighter, colors)
                        highlighter.set("Visual", { bg = "#262626" })
                        -- highlighter.set("Visual", { reverse = true })
                        highlighter.set("MatchParen", { bold = true })
                        highlighter.set("TreesitterContext", { bg = "#191919" })
                        highlighter.set("CursorLineNr", { fg = colors.blue })
                        highlighter.set("TelescopeMatching", { fg = colors.blue })
                        highlighter.set("@lsp.type.property", { fg = colors.cyan }) -- e.g., fg and cyan
                        highlighter.set("@property", { fg = colors.cyan }) -- e.g., fg and cyan
                        highlighter.set("@lsp.type.parameter", { fg = colors.yellow }) -- e.g., "highlighter" in highlighter.set
                        highlighter.set("@parameter", { fg = colors.yellow }) -- e.g., "highlighter" in highlighter.set
                        highlighter.set("TroubleNormal", { bg = "none" })
                        highlighter.set("TroubleNormalNC", { bg = "none" })
                    end,
                },
                transparent_background = {
                    enabled = false, -- problems with this
                    floating_windows = false,
                    telescope = false,
                    file_tree = false,
                    cursor_line = false,
                    status_line = false,
                },
                plugins = {
                    cmp = true,
                    gitsigns = true,
                    indent_blankline = true,
                    nvim_tree = {
                        enabled = true,
                        show_root = true,
                    },
                    neo_tree = {
                        enabled = false,
                    },
                    startify = false,
                },
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false, -- ensure main colorscheme loaded on start up
        priority = 1000, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require("tokyonight").setup({
                style = "night",
                styles = {
                    functions = { bold = true },
                    sidebars = "dark",
                    floats = "dark",
                },
                lualine_bold = true,
                on_colors = function(colors)
                    colors.border = colors.fg_dark
                end,
                on_highlights = function(highlights, colors)
                    highlights["WinBar"] = { bg = "none", italic = true }
                    highlights["WinBarNC"] = { bg = "none", italic = true }
                    -- highlights['Visual'] = { bg = colors.bg_visual, reverse = true }
                    highlights["LineNr"] = { fg = "#696d87" } -- line number color
                    highlights["CursorLineNr"] = { fg = colors.fg } -- cursor line number color
                    highlights["TelescopeSelection"] = { bg = colors.bg_visual }
                    -- swap undercurl for underdot
                    highlights["DiagnosticUnderlineError"] = { underdotted = true }
                    highlights["DiagnosticUnderlineWarn"] = { underdotted = true }
                    highlights["DiagnosticUnderlineInfo"] = { underdotted = true }
                    highlights["DiagnosticUnderlineHint"] = { underdotted = true }
                    highlights["@lsp.type.unresolvedReference"] = { underdotted = true }
                    highlights["SpellBad"] = { underdotted = true }
                    highlights["SpellCap"] = { underdotted = true }
                end,
            })
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 999, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require("kanagawa").setup({
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                        wave = {
                            ui = {
                                bg_visual = "#45475a",
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        WinSeparator = { fg = theme.ui.nontext },
                        -- Visual = { reverse = true },
                        WinBar = { bg = "none", italic = true },
                        WinBarNC = { bg = "none", italic = true },
                        DiagnosticUnderlineError = { underdotted = true },
                        DiagnosticUnderlineWarn = { underdotted = true },
                        DiagnosticUnderlineInfo = { underdotted = true },
                        DiagnosticUnderlineHint = { underdotted = true },
                        ["@lsp.type.unresolvedReference"] = { underdotted = true },
                    }
                end,
            })
        end,
    },
    {
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        config = function()
            require("kanagawa-paper").setup({
                transparent = true,
                dimInactive = false,
                functionStyle = { bold = true },
                keywordStyle = { bold = true },
                typeStyle = { italic = true },
                overrides = function(colors)
                    return {
                        WinBar = { fg = colors.palette.fujiWhite },
                        WinBarNC = { fg = colors.palette.fujiWhite },
                    }
                end,
            })
        end,
    },
    {
        "vague2k/vague.nvim",
        lazy = false,
        config = function()
            require("vague").setup({
                transparent = false,
                style = {
                    functions = "bold",
                    keywords = "bold",
                    strings = "none",
                },
            })
        end,
    },
    {
        "cdmill/neomodern.nvim",
        lazy = false,
        config = function()
            require("neomodern").setup({
                theme = "roseprime",
                transparent = false,
                code_style = {
                    functions = "bold",
                    keywords = "bold",
                    string = "none",
                },
            })
            require("neomodern").load()
        end,
    },
    {
        "ilof2/posterpole.nvim",
        lazy = false,
        config = function()
            require("posterpole").setup({
                transparent = true,
                colorless_bg = false, -- grayscale or not
                dim_inactive = false, -- highlight inactive splits
                brightness = 0, -- negative numbers - darker, positive - lighter
                selected_tab_highlight = false, --highlight current selected tab
                fg_saturation = 0, -- font saturation, gray colors become more brighter
                bg_saturation = 0, -- background saturation
            })
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 998, -- ensure colorscheme loaded before all other start up plugins
        lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                -- transparent_background = true, -- built-in transparency; doesn't suit all my needs
                custom_highlights = function(colors)
                    return {
                        TreesitterContext = { bg = colors.surface2 },
                        TreesitterContextLineNumber = { fg = colors.surface2, bg = "none" },
                        WinSeparator = { fg = colors.overlay0 },
                        LineNr = { fg = colors.overlay0 },
                        -- Visual = { reverse = true },
                        WinBar = { fg = "none", bg = "none", italic = true },
                        WinBarNC = { bg = "none", italic = true },
                        DiagnosticUnderlineError = { underdotted = true },
                        DiagnosticUnderlineWarn = { underdotted = true },
                        DiagnosticUnderlineInfo = { underdotted = true },
                        DiagnosticUnderlineHint = { underdotted = true },
                        ["@lsp.type.unresolvedReference"] = { underdotted = true },
                        RenameMatch = { link = "Search" },
                        Pmenu = { bg = colors.crust },
                        TroubleNormal = { bg = "none" },
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
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                    },
                    treesitter_context = true,
                    which_key = true,
                },
            })
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        -- for local dev:
        -- name = 'rose-pine.nvim',
        -- dev = true,
        lazy = false,
        priority = 997, -- ensure colorscheme loaded before all other start up plugins
        config = function()
            require("rose-pine").setup({
                variant = "main",
                styles = {
                    bold = true,
                    italic = true,
                    -- transparency = true,
                },
                highlight_groups = {
                    TreesitterContext = { bg = "foam", blend = 10 },
                    -- Visual = { reverse = true },
                    WinBar = { bg = "none", italic = true, inherit = false },
                    WinBarNC = { bg = "none", italic = true, inherit = false },
                    WinSeparator = { fg = "muted", bg = "none" },
                    -- for transparency, otherwise bg remains in signcolumn
                    GitSignsAdd = { bg = "none" },
                    GitSignsDelete = { bg = "none" },
                    GitSignsChange = { bg = "none" },
                    DiagnosticUnderlineError = { underdotted = true },
                    DiagnosticUnderlineWarn = { underdotted = true },
                    DiagnosticUnderlineInfo = { underdotted = true },
                    DiagnosticUnderlineHint = { underdotted = true },
                    ["@lsp.type.unresolvedReference"] = { underdotted = true },
                },
            })
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 996,
        config = function()
            require("gruvbox").setup({
                invert_selection = true,
                overrides = {
                    WinSeparator = { bg = "none" },
                    CursorLineNr = { bg = "none" },
                    WinBar = { bg = "none", italic = true },
                    WinBarNC = { bg = "none", italic = true },
                },
                transparent_mode = true,
            })
        end,
    },
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 995,
        init = function()
            -- can be 'material', 'mix', or 'original'
            vim.g.gruvbox_material_foreground = "material"
            vim.g.gruvbox_material_enable_bold = true
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_transparent_background = true
        end,
    },
    {
        "savq/melange-nvim",
        lazy = false,
    },
    {
        "nyngwang/nvimgelion",
        -- 'winter-again/nvimgelion',
        -- dev = true,
        config = function() end,
    },
    {
        "hachy/eva01.vim",
        lazy = false,
    },
    {
        "winter-again/seoul256.nvim",
        -- dev = true,
        branch = "fix-indent-blankline",
    },
    {
        "AlexvZyl/nordic.nvim",
        lazy = false,
        config = function()
            local palette = require("nordic.colors")
            require("nordic").setup({
                transparent = { bg = true },
                on_highlight = function(highlights, palette)
                    highlights.WinSeparator = { fg = palette.white0, bg = "none" }
                    -- Visual = { reverse = true },
                    highlights.GitSignsAdd = { bg = "none" }
                    highlights.GitSignsDelete = { bg = "none" }
                    highlights.GitSignsChange = { bg = "none" }
                    highlights.FoldColumn = { bg = "none" }
                end,
            })
            require("nordic").load()
        end,
    },
    {
        "mcchrish/zenbones.nvim",
        lazy = false,
        dependencies = { "rktjmp/lush.nvim" },
        init = function()
            vim.g.zenbones_darkness = "warm"
        end,
    },
    {
        "slugbyte/lackluster.nvim",
        lazy = false,
        config = function() end,
    },
    {
        "mellow-theme/mellow.nvim",
        lazy = false,
        init = function()
            vim.g.mellow_bold_keywords = true
            vim.g.mellow_bold_functions = true
            vim.g.mellow_transparent = true
        end,
    },
}
