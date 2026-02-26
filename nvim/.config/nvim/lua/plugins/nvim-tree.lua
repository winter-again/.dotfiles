return {
    'nvim-tree/nvim-tree.lua',
    keys = '<leader>pv',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    tag = 'nightly',
    config = function()
        require('nvim-tree').setup({
            -- disable_netrw = false and hijack_netrw = true should mean netrw
            -- can be used for following links as usual but not for its file browsing functionality
            disable_netrw = false,
            hijack_netrw = true,
            hijack_cursor = true, -- keep cursor on first letter of file when moving
            view = {
                -- preserve_window_proportions = true,
                float = {
                    enable = true,
                    quit_on_focus_loss = false,
                    open_win_config = {
                        relative = 'editor',
                        border = 'rounded',
                        width = 30,
                        height = 50,
                    },
                },
            },
            -- LSP diagnostics in tree
            diagnostics = {
                enable = false,
            },
            git = {
                enable = true,
                ignore = false,
            },
            renderer = {
                highlight_opened_files = 'name',
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        git = {
                            unstaged = '✗', -- default
                            staged = '✓', -- default
                            unmerged = '', -- default
                            renamed = 'R',
                            untracked = 'U', -- e.g., new file; took default "unstaged" icon
                            deleted = 'D',
                            ignored = '◌', -- default
                        },
                    },
                },
            },
        })
        Map('n', '<leader>pv', '<cmd>NvimTreeToggle<CR>', { silent = true }, 'Toggle nvim-tree') -- set here since the plugin is loaded on this command
    end,
}
