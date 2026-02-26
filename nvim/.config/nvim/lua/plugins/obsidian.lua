return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- latest release
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
    },
    -- enabled = false,
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
                blink = false,
                min_chars = 2,
                match_case = false,
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

                if title ~= nil then
                    title = title:gsub(" ", "-")
                    return title
                else
                    print("Must provide title. Using 'untitled' for now...")
                    return "untitled"
                end
            end,
            markdown_link_func = function(opts)
                local util = require("obsidian.util")
                local anchor = ""
                local header = ""
                if opts.anchor then
                    anchor = opts.anchor.anchor
                    header = util.format_anchor_label(opts.anchor)
                elseif opts.block then
                    anchor = "#" .. opts.block.id
                    header = "#" .. opts.block.id
                end

                -- NOTE: identical to default except that I use spaces instead of dashes to separate
                local label = opts.label:gsub("-", " ")
                local path = util.urlencode(opts.path, { keep_path_sep = true })
                return string.format("[%s%s](%s%s)", label, header, path, anchor)

                -- NOTE: default func
                -- return require("obsidian.util").markdown_link(opts)
            end,
            ---@param opts obsidian.link.LinkCreationOpts
            ---@return string
            wiki_link_func = function(opts)
                local anchor = ""
                local header = ""
                if opts.anchor then
                    anchor = opts.anchor.anchor
                    header = string.format(" ❯ %s", opts.anchor.header)
                elseif opts.block then
                    anchor = "#" .. opts.block.id
                    header = "#" .. opts.block.id
                end

                if opts.label ~= opts.path then
                    return string.format("[[%s%s|%s%s]]", opts.path, anchor, opts.label, header)
                else
                    return string.format("[[%s%s]]", opts.path, anchor)
                end
            end,
            preferred_link_style = "markdown", -- still able to autocomplete both types
            frontmatter = {
                enabled = false,
            },
            templates = {
                folder = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%I:%M %m",
                substitutions = {
                    -- NOTE: convert title like "notes-on-something" to "Notes on something"
                    note_title = function(ctx)
                        local id = ctx.partial_note.id
                        id = id:gsub("-", " "):gsub("^%l", string.upper)
                        return id
                    end,
                    meeting_note_title = function(ctx)
                        local id = ctx.partial_note.id
                        return id:sub(12, -1)
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
            picker = {
                name = "fzf-lua",
            },
            backlinks = {
                parse_headers = false, -- disables header parsing for Obsidian backlinks
            },
            search = { sort_by = "modified", sort_reversed = true, max_lines = 1000 },
            open_notes_in = "current",
            ui = {
                enable = false, -- set to false to disable all additional syntax features
            },
            -- NOTE: I don't rely on this functionality
            attachments = {
                folder = "assets",
            },
            footer = {
                enabled = false,
            },
        })

        local map = require("winter-again.globals").map
        local opts = { silent = true }

        -- map("n", "<leader>nn", function()
        --     vim.cmd("Obsidian new_from_template")
        -- end, opts, "Create new note with template")
        -- map("n", "<leader>ni", function()
        --     vim.cmd("Obsidian template")
        -- end, opts, "Insert template into current note")
        -- map("n", "<leader>fn", function()
        --     vim.cmd("Obsidian quick_switch")
        -- end, opts, "Search notes by title")

        -- map("n", "<leader>ns", function()
        --     vim.cmd("Obsidian search")
        -- end, opts, "Search notes with ripgrep")

        -- map("n", "<leader>nt", function()
        --     vim.cmd("Obsidian tags")
        -- end, opts, "Search notes by tag")

        map("n", "<leader>nl", function()
            vim.cmd("Obsidian links")
        end, opts, "Search current note's links")
        map("n", "<leader>nb", function()
            vim.cmd("Obsidian backlinks")
        end, opts, "Search current note's backlinks")
    end,
}
