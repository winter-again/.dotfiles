--- @diagnostic disable: missing-fields
return {
    "epwalsh/obsidian.nvim",
    enabled = false,
    version = "*", -- latest release
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    lazy = true,
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
    },
    config = function()
        require("obsidian").setup({
            workspaces = {
                {
                    name = "notes",
                    path = "~/Documents/notebook",
                },
            },
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
            mappings = {
                -- overrides the gf mapping to work on markdown/wiki links within vault
                -- TODO: use own fzf-lua funcs if colors are broken?
                -- ["gf"] = {
                --     action = function()
                --         return require("obsidian").util.gf_passthrough()
                --     end,
                --     opts = { noremap = false, expr = true, buffer = true },
                -- },
                -- ["<leader>fn"] = {
                --     action = function()
                --         vim.cmd("ObsidianQuickSwitch")
                --     end,
                --     opts = { silent = true, noremap = true, buffer = true, desc = "Search notes by title" },
                -- },
                -- ["<leader>fs"] = {
                --     action = function()
                --         vim.cmd("ObsidianSearch")
                --     end,
                --     opts = { silent = true, noremap = true, buffer = true, desc = "Search notes by content" },
                -- },
                ["<leader>ft"] = {
                    action = function()
                        vim.cmd("ObsidianTags")
                    end,
                    opts = { silent = true, noremap = true, buffer = true, desc = "Search notes by tag" },
                },
                ["<leader>nl"] = {
                    action = function()
                        vim.cmd("ObsidianLinks")
                    end,
                    opts = { silent = true, noremap = true, buffer = true, desc = "Search buffer links" },
                },
                ["<leader>nb"] = {
                    action = function()
                        vim.cmd("ObsidianBacklinks")
                    end,
                    opts = { silent = true, noremap = true, buffer = true, desc = "Search buffer backlinks" },
                },
                ["<leader>nt"] = {
                    action = function()
                        vim.cmd("ObsidianTemplate")
                    end,
                    opts = { silent = true, noremap = true, buffer = true, desc = "Insert template into current note" },
                },
            },
            new_notes_location = "current_dir",
            -- NOTE: just use the note name for the title
            note_id_func = function(title)
                if title ~= nil then
                    return title:gsub(" ", "-")
                else
                    print("Must provide a title")
                end
            end,
            wiki_link_func = "prepend_note_path",
            markdown_link_func = function(opts)
                return require("obsidian.util").markdown_link(opts)
            end,
            preferred_link_style = "markdown", -- still able to autocomplete both types
            -- TODO: there might be a bug when true where ObsidianNewFromTemplate doesn't insert
            -- frontmatter; also don't like the autoformatting right now
            disable_frontmatter = true,
            templates = {
                folder = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%I:%M %m",
                -- map of custom variables
                substitutions = {},
            },
            follow_url_func = function(url)
                vim.fn.jobstart({ "xdg-open", url })
            end,
            picker = {
                name = "fzf-lua",
            },
            sort_by = "modified",
            sort_reversed = true,
            ui = {
                enable = false, -- set to false to disable all additional syntax features
                update_debounce = 200, -- update delay after a text change (in milliseconds)
                max_file_length = 5000,
                checkboxes = {
                    -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                    -- [" "] = { char = "󰄱", hl_group = "@markup.list" },
                    -- ["x"] = { char = "", hl_group = "@markup.list.checked" },
                    -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                    -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                },
                -- bullets = { char = "•", hl_group = "ObsidianBullet" },
                bullets = {}, -- set empty to disable
                -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                external_link_icon = {},
                -- reference_text = { hl_group = "ObsidianRefText" },
                -- highlight_text = { hl_group = "ObsidianHighlightText" },
                -- tags = { hl_group = "ObsidianTag" },
                -- block_ids = { hl_group = "ObsidianBlockID" },
                hl_groups = {
                    -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                    -- ObsidianTodo = { bold = true, fg = "#7aa2f7" },
                    -- ObsidianDone = { bold = true, fg = "none" },
                    -- ObsidianRightArrow = { bold = true, fg = "#c0caf5" },
                    -- ObsidianTilde = { bold = true, fg = "#c0caf5" },
                    -- ObsidianRefText = { fg = "#c0caf5", underline = true },
                    -- ObsidianExtLinkIcon = { fg = "#7aa2f7" },
                    -- ObsidianTag = { fg = "#7aa2f7" },
                    -- ObsidianHighlightText = { bg = "#9ece6a" },
                },
            },
            attachments = {
                img_folder = "assets",
            },
        })

        local fzf_lua = require("fzf-lua")
        local map = require("winteragain.globals").map
        local opts = { silent = true }
        local notes_dir = "~/Documents/notebook"

        map("n", "<leader>fn", function()
            fzf_lua.files({ cwd = notes_dir, fd_opts = "--color=never --type f -e md --hidden --follow" })
        end, opts, "Search notes")
        map("n", "<leader>ns", function()
            fzf_lua.live_grep({ cwd = notes_dir, exec_empty_query = true })
        end, opts, "Live grep notes")
    end,
}
