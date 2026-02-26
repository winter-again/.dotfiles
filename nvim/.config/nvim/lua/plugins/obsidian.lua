return {
    "epwalsh/obsidian.nvim",
    version = "*", -- latest release
    lazy = true,
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Documents/obsidian-vault/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/obsidian-vault/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        vim.opt_local.conceallevel = 1 -- conceal level for buffer; only want for the Obsidian vault
        require("obsidian").setup({
            workspaces = {
                {
                    name = "notes",
                    path = "~/Documents/obsidian-vault",
                },
            },
            wiki_link_func = function(opts)
                return require("obsidian.util").prepend_note_id(opts)
            end,
            new_notes_location = "current_dir",
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
            ui = {
                enable = true, -- set to false to disable all additional syntax features
                update_debounce = 200, -- update delay after a text change (in milliseconds)
                -- Define how various check-boxes are displayed
                checkboxes = {
                    -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                    [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                    ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                },
                external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                reference_text = { hl_group = "ObsidianRefText" },
                highlight_text = { hl_group = "ObsidianHighlightText" },
                tags = { hl_group = "ObsidianTag" },
                hl_groups = {
                    -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                    ObsidianTodo = { bold = true, fg = "#7aa2f7" },
                    ObsidianDone = { bold = true, fg = "none" },
                    ObsidianRightArrow = { bold = true, fg = "#c0caf5" },
                    ObsidianTilde = { bold = true, fg = "#c0caf5" },
                    ObsidianRefText = { underline = true, fg = "#9d7cd8" },
                    ObsidianExtLinkIcon = { fg = "#7dcfff" },
                    ObsidianTag = { italic = true, fg = "#7aa2f7" },
                    ObsidianHighlightText = { bg = "#9ece6a" },
                },
            },
            -- don't manage frontmatter, which can also be configured in note_frontmatter_func opt
            -- was also culprit of the formatting of frontmtter on save
            disable_frontmatter = true,
            templates = {
                subidr = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%I:%M %m",
            },
            follow_url_func = function(url)
                vim.fn.jobstart({ "xdg-open", url })
            end,
            attachments = {
                img_folder = "assets",
            },
        })
    end,
}
