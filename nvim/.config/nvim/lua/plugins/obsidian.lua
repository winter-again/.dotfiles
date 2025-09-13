return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- latest release
    keys = {
        "<leader>nn",
        "<leader>fn",
        "<leader>ns",
        "<leader>nt",
        "<leader>nl",
        "<leader>nb",
    },
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
    },
    config = function()
        require("obsidian").setup({
            legacy_commands = false,
            workspaces = {
                {
                    path = "~/Documents/notebook",
                },
            },
            notes_subdir = "notes",
            -- NOTE: set higher thresh because of frontmatter validation
            -- warning for template files; claims {{title}} is invalid value
            log_level = vim.log.levels.ERROR,
            new_notes_location = "notes_subdir",
            completion = {
                nvim_cmp = false,
                blink = true,
                min_chars = 2,
                create_new = false,
            },
            -- NOTE: use note title for file name
            note_id_func = function(title)
                -- local suffix = ""
                -- if title ~= nil then
                --     -- If title is given, transform it into valid file name.
                --     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                -- else
                --     -- If title is nil, just add 4 random uppercase letters to the suffix.
                --     for _ = 1, 4 do
                --         suffix = suffix .. string.char(math.random(65, 90))
                --     end
                -- end
                -- return tostring(os.time()) .. "-" .. suffix

                -- if title ~= nil then
                --     return title:gsub(" ", "-")
                -- else
                --     print("Must provide a title")
                -- end
                return title:gsub(" ", "-")
            end,
            -- NOTE: default func
            markdown_link_func = function(opts)
                return require("obsidian.util").markdown_link(opts)
            end,
            preferred_link_style = "markdown", -- still able to autocomplete both types
            disable_frontmatter = true,
            -- TODO: note_frontmatter_func()?
            templates = {
                folder = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%I:%M %m",
                substitutions = {
                    -- NOTE: convert title like "notes-on-something" to "Notes on something"
                    note_title = function(ctx)
                        local id = ctx.partial_note.id
                        return id:gsub("-", " "):gsub("^%l", string.upper)
                    end,
                },
                customizations = {
                    ["meeting-templ"] = {
                        notes_subdir = "meetings",
                        note_id_func = function(title)
                            local today = os.date("%Y-%m-%d")
                            title = title:gsub(" ", "-")
                            return string.format("%s-%s", today, title)
                        end,
                    },
                },
            },
            -- TODO: already default?
            -- there's also follow_img_func
            -- follow_url_func = function(url)
            --     vim.ui.open(url)
            -- end,
            picker = {
                name = "fzf-lua",
            },
            -- TODO: figure out behavior of this
            -- I think this pertains to :ObsidianBacklinks func
            backlinks = {
                parse_headers = false, -- get from whole note?
            },
            sort_by = "modified",
            sort_reversed = true,
            search_max_lines = 1000,
            open_notes_in = "current",
            ui = {
                enable = false, -- set to false to disable all additional syntax features
                -- ignore_conceal_warn = true, -- set to true to disable conceallevel specific warning
                -- update_debounce = 200, -- update delay after a text change (in milliseconds)
                -- max_file_length = 5000, -- disable UI features for files with more than this many lines
                -- Define how various check-boxes are displayed
                -- checkboxes = {
                --     -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                --     [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                --     ["x"] = { char = "", hl_group = "ObsidianDone" },
                -- },
                -- Use bullet marks for non-checkbox lists.
                -- bullets = { char = "•", hl_group = "ObsidianBullet" },
                -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                -- Replace the above with this if you don't have a patched font:
                -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                -- reference_text = { hl_group = "ObsidianRefText" },
                -- highlight_text = { hl_group = "ObsidianHighlightText" },
                -- tags = { hl_group = "ObsidianTag" },
                -- block_ids = { hl_group = "ObsidianBlockID" },
                -- hl_groups = {
                --     -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                --     ObsidianTodo = { bold = true, fg = "#f78c6c" },
                --     ObsidianDone = { bold = true, fg = "#89ddff" },
                --     ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
                --     ObsidianTilde = { bold = true, fg = "#ff5370" },
                --     ObsidianImportant = { bold = true, fg = "#d73128" },
                --     ObsidianBullet = { bold = true, fg = "#89ddff" },
                --     ObsidianRefText = { underline = true, fg = "#c792ea" },
                --     ObsidianExtLinkIcon = { fg = "#c792ea" },
                --     ObsidianTag = { italic = true, fg = "#89ddff" },
                --     ObsidianBlockID = { italic = true, fg = "#89ddff" },
                --     ObsidianHighlightText = { bg = "#75662e" },
                -- },
            },
            -- TODO: figure this out
            -- attachments = {
            --     img_folder = "assets",
            -- },
            footer = {
                enabled = false,
            },
        })

        local map = require("winter-again.globals").map
        local opts = { silent = true }

        map("n", "<leader>nn", function()
            vim.cmd("Obsidian new_from_template")
        end, opts, "Create new note with template")
        map("n", "<leader>fn", function()
            vim.cmd("Obsidian quick_switch")
        end, opts, "Search notes by title")
        map("n", "<leader>ns", function()
            vim.cmd("Obsidian search")
        end, opts, "Search notes with ripgrep")
        map("n", "<leader>nt", function()
            vim.cmd("Obsidian tags")
        end, opts, "Search notes by tag")
        map("n", "<leader>nl", function()
            vim.cmd("Obsidian links")
        end, opts, "Search current note's links")
        map("n", "<leader>nb", function()
            vim.cmd("Obsidian backlinks")
        end, opts, "Search current note's backlinks")
        map("n", "<leader>ni", function()
            vim.cmd("Obsidian template")
        end, opts, "Insert template into current note")
    end,
}
