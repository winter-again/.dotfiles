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
                    -- Replace the above with this if you don't have a patched font:
                    -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                    -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

                    -- You can also add more custom ones...
                },
                external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
                -- Replace the above with this if you don't have a patched font:
                -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                reference_text = { hl_group = 'ObsidianRefText' },
                highlight_text = { hl_group = 'ObsidianHighlightText' },
                tags = { hl_group = 'ObsidianTag' },
                hl_groups = {
                    -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                    ObsidianTodo = { bold = true, fg = '#f78c6c' },
                    ObsidianDone = { bold = true, fg = '#89ddff' },
                    ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
                    ObsidianTilde = { bold = true, fg = '#ff5370' },
                    ObsidianRefText = { underline = true, fg = '#c792ea' },
                    ObsidianExtLinkIcon = { fg = '#c792ea' },
                    ObsidianTag = { italic = true, fg = '#89ddff' },
                    ObsidianHighlightText = { bg = '#75662e' },
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
            follow_url_func = function(url)
                vim.fn.jobstart({ 'xdg-open', url })
            end,
            attachments = {
                img_folder = 'assets',
            },
        })
    end,
}
