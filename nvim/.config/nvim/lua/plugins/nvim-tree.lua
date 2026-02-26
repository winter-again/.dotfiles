return {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    tag = 'nightly',
    config = function()
        require('nvim-tree').setup({
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = true, -- keep cursor on first letter of file when moving
            view = {
                width = 30,
                -- float = {
                --     enable = true,
                --     quit_on_focus_loss = true,
                --     open_win_config = {
                --         width = 30,
                --         height = 80
                --     }
                -- }
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
    end,
}
