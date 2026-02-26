return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-mini/mini.icons",
    },
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
    },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
        completions = {
            lsp = { enabled = false },
        },
        render_modes = true, -- retain rendering in all modes; less jarring
        -- patterns = {
        --     markdown = {
        --         -- NOTE: not sure why but seem to need this for my custom queries to consistently apply
        --         disable = true,
        --     },
        -- },
        anti_conceal = {
            -- disable rendering for the cursor line only
            enabled = true,
            -- can retain rendering for some elements
            ignore = {
                bullet = true,
                dash = true,
                latex = true,
                quote = true,
            },
        },
        -- win_options = {
        --     conceallevel = { rendered = 2 },
        --     concealcursor = { rendered = "" },
        -- },
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
                scope_highlight = "@markup.list.checked",
            },
        },
        code = {
            enabled = false,
            sign = false,
            conceal_delimiters = false,
            style = "language",
            border = "none",
            language_icon = true,
            language_name = false,
            language_info = false,
            language_border = " ",
            language_left = "█",
            -- language_right = "█",
            -- language_right = "▋",
            highlight_border = "@markup.raw",
        },
        dash = {
            enabled = true,
            width = "full",
        },
        document = { enabled = false },
        heading = {
            enabled = true,
            sign = false,
            position = "inline",
            -- width = "block",
            -- min_width = 30,
            icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
            -- icons = { "󰎦 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
            -- icons = { "◉ ", "○ ", "✸ ", "✿ " }, -- from org-mode
        },
        indent = {
            enabled = false,
            icon = "",
        },
        latex = {
            enabled = false,
        },
        link = {
            enabled = true,
            footnote = {
                enabled = false,
            },
            image = "",
            email = "",
            hyperlink = "",
            wiki = {
                icon = "",
            },
            custom = {
                web = { pattern = "^http", icon = "" },
                apple = { pattern = "apple%.com", icon = "" },
                discord = { pattern = "discord%.com", icon = "" },
                github = { pattern = "github%.com", icon = "" },
                gitlab = { pattern = "gitlab%.com", icon = "" },
                google = { pattern = "google%.com", icon = "" },
                hackernews = { pattern = "ycombinator%.com", icon = "" },
                linkedin = { pattern = "linkedin%.com", icon = "" },
                microsoft = { pattern = "microsoft%.com", icon = "" },
                neovim = { pattern = "neovim%.io", icon = "" },
                reddit = { pattern = "reddit%.com", icon = "" },
                slack = { pattern = "slack%.com", icon = "" },
                stackoverflow = { pattern = "stackoverflow%.com", icon = "" },
                steam = { pattern = "steampowered%.com", icon = "" },
                twitter = { pattern = "x%.com", icon = "" },
                wikipedia = { pattern = "wikipedia%.org", icon = "" },
                youtube = { pattern = "youtube[^.]*%.com", icon = "" },
                youtube_short = { pattern = "youtu%.be", icon = "" },
            },
        },
        paragraph = { enabled = false },
        quote = {
            enabled = true,
            -- icon = "┃",
        },
        pipe_table = { enabled = false },
        sign = { enabled = false },
        inline_highlight = { enabled = false },
        html = { enabled = false },
    },
}
