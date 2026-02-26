--- @diagnostic disable: missing-fields
return {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    event = {
        'BufReadPre ' .. vim.fn.expand('~') .. '/Documents/andrew-obsidian/**.md',
        'BufNewFile ' .. vim.fn.expand('~') .. '/Documents/andrew-obsidian/**.md',
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        require('obsidian').setup({
            workspaces = {
                {
                    name = 'andrew-obsidian',
                    path = '~/Documents/andrew-obsidian',
                },
            },
            completion = {
                nvim_cmp = true,
                min_chars = 2,
                new_notes_location = 'current_dir',
                -- Control how wiki links are completed with these (mutually exclusive) options:
                --
                -- 1. Whether to add the note ID during completion.
                -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
                -- Mutually exclusive with 'prepend_note_path' and 'use_path_only'.
                prepend_note_id = false,
                -- 2. Whether to add the note path during completion.
                -- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
                -- Mutually exclusive with 'prepend_note_id' and 'use_path_only'.
                prepend_note_path = false,
                -- 3. Whether to only use paths during completion.
                -- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
                -- Mutually exclusive with 'prepend_note_id' and 'prepend_note_path'.
                use_path_only = true,
            },
            ui = {
                enable = true, -- set to false to disable all additional syntax features
                update_debounce = 200, -- update delay after a text change (in milliseconds)
                -- Define how various check-boxes are displayed
                checkboxes = {
                    -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                    [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
                    ['x'] = { char = '', hl_group = 'ObsidianDone' },
                    ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
                    ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
                },
                external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
                reference_text = { hl_group = 'ObsidianRefText' },
                highlight_text = { hl_group = 'ObsidianHighlightText' },
                tags = { hl_group = 'ObsidianTag' },
                hl_groups = {
                    -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                    ObsidianTodo = { bold = true, fg = '#7aa2f7' },
                    ObsidianDone = { bold = true, fg = 'none' },
                    ObsidianRightArrow = { bold = true, fg = '#c0caf5' },
                    ObsidianTilde = { bold = true, fg = '#c0caf5' },
                    ObsidianRefText = { underline = true, fg = '#9d7cd8' },
                    ObsidianExtLinkIcon = { fg = '#7dcfff' },
                    ObsidianTag = { italic = true, fg = '#7aa2f7' },
                    ObsidianHighlightText = { bg = '#9ece6a' },
                },
            },
            -- don't manage frontmatter, which can also be configured in note_frontmatter_func opt
            -- was also culprit of the formatting of frontmtter on save
            disable_frontmatter = true,
            templates = {
                subidr = 'templates',
                date_format = '%Y-%m-%d',
                time_format = '%I:%M %m',
            },
            follow_url_func = function(url)
                vim.fn.jobstart({ 'xdg-open', url })
            end,
            attachments = {
                img_folder = 'assets',
            },
        })
    end,
}
