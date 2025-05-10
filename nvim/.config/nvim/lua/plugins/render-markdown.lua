return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = {
            lsp = { enabled = false },
        },
        render_modes = true, -- retain rendering in all modes; less jarring
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
            enabled = false,
            sign = false,
            position = "inline",
            width = "block",
        },
        paragraph = { enabled = false },
        code = {
            enabled = false,
            sign = false,
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
            unchecked = {
                icon = "󰄱",
            },
            checked = {
                icon = "",
                scoped_highlight = "@markup.list.checked_item",
            },
        },
        quote = {
            enabled = true,
            icon = "┃",
        },
        pipe_table = { enabled = false },
        link = { enabled = false },
        sign = { enabled = false },
        inline_highlight = { enabled = false },
        indent = { enabled = false },
        html = { enabled = false },
    },
}
