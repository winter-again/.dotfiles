return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    event = { "BufReadPost", "BufNewFile" },
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = {
            lsp = { enabled = false },
        },
        render_modes = true, -- retain rendering in all modes; less jarring
        patterns = {
            markdown = {
                -- NOTE: not sure why but seem to need this for my custom queries to consistently apply
                disable = true,
            },
        },
        anti_conceal = {
            -- disable rendering for the cursor line
            enabled = true,
            -- can retain rendering for some
            ignore = { bullet = false, check_icon = false },
        },
        latex = {
            enabled = false,
        },
        heading = {
            enabled = true,
            sign = false,
            position = "inline",
            width = "block",
            -- icons = { "󰎦 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
            icons = { " 󰉫 ", " 󰉬 ", " 󰉭 ", " 󰉮 ", " 󰉯 ", " 󰉰 " },
            -- icons = { "◉ ", "○ ", "✸ ", "✿ " },
            -- left_pad = 1,
        },
        paragraph = { enabled = false },
        code = {
            enabled = false,
            sign = false,
            -- conceal_delimiters = false,
            style = "language",
            border = "none",
        },
        dash = {
            enabled = true,
            width = "full",
        },
        document = { enabled = false },
        bullet = {
            enabled = true,
            icons = { "•" },
        },
        checkbox = {
            enabled = true,
            right_pad = 1,
            -- NOTE: these highlights only apply to the virtual/rendered text,
            -- not the underlying text
            unchecked = {
                icon = "󰄱",
                highlight = "@markup.list.unchecked",
            },
            checked = {
                icon = "",
                highlight = "@markup.list.checked", -- icon highlight
                scope_highlight = "@markup.list.checked", -- item highlight
            },
        },
        quote = {
            enabled = true,
            -- icon = "┃",
        },
        pipe_table = { enabled = false },
        link = { enabled = false },
        sign = { enabled = false },
        inline_highlight = { enabled = false },
        indent = { enabled = false },
        html = { enabled = false },
    },
}
