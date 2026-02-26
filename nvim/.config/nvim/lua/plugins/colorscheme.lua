return {
    {
        "winter-again/winter-again.nvim",
        lazy = false,
        priority = 1000,
        dev = true,
        config = function()
            require("winter-again").setup({
                saturation = 0,
                brightness = 0,
                text_styles = {
                    numbers = { italic = false },
                    floats = { italic = false },
                },
                plugins = {},
                hl_overrides = function(colors)
                    return {
                        -- ["MatchParen"] = { bold = false, italic = true }
                        ["@markup.math"] = { italic = true },
                        ["QuickFixLine"] = { bold = true },
                        ["@keyword.luadoc"] = { bold = false },
                        ["@markup.list.checked"] = { strikethrough = false },
                        ["RenderMarkdownH1Bg"] = { link = "RenderMarkdownH1" },
                        ["RenderMarkdownH2Bg"] = { link = "RenderMarkdownH2" },
                        ["RenderMarkdownH3Bg"] = { link = "RenderMarkdownH3" },
                        ["RenderMarkdownH4Bg"] = { link = "RenderMarkdownH4" },
                        ["RenderMarkdownH5Bg"] = { link = "RenderMarkdownH5" },
                        ["RenderMarkdownH6Bg"] = { link = "RenderMarkdownH6" },
                        -- ["markdownH1"] = { reverse = false, underline = true },
                        -- ["markdownH2"] = { reverse = false, underline = true },
                        -- ["markdownH3"] = { reverse = false, underline = true },
                        -- ["markdownH4"] = { reverse = false, underline = true },
                        -- ["markdownH5"] = { reverse = false, underline = true },
                        -- ["markdownH6"] = { reverse = false, underline = true },
                        -- ["@markup.heading.1.html"] = { fg = colors.fg },
                        -- ["@markup.heading.2.html"] = { fg = colors.fg },
                        -- ["@markup.heading.3.html"] = { fg = colors.fg },
                        -- ["@markup.heading.4.html"] = { fg = colors.fg },
                        -- ["@markup.heading.5.html"] = { fg = colors.fg },
                        -- ["@markup.heading.6.html"] = { fg = colors.fg },
                    }
                end,
            })
        end,
    },
    {
        "ramojus/mellifluous.nvim",
        lazy = false,
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
        "rebelot/kanagawa.nvim",
        enabled = false,
        lazy = false,
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
        -- enabled = false,
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
                theme = "hojicha",
                transparent = true,
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
        "slugbyte/lackluster.nvim",
        lazy = false,
        config = function() end,
    },
}
