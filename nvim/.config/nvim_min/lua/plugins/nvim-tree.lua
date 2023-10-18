return {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    tag = 'nightly',
    config = function()
        -- local HEIGHT_RATIO = 0.8 -- You can change this
        -- local WIDTH_RATIO = 0.5 -- You can change this too

        require('nvim-tree').setup({
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = true, -- keep cursor on first letter of file when moving
            -- for having a centered, floating window
            -- view = {
            --     float = {
            --         enable = true,
            --         quit_on_focus_loss = true,
            --         open_win_config = function()
            --             local screen_w = vim.opt.columns:get()
            --             local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            --             local window_w = screen_w * WIDTH_RATIO
            --             local window_h = screen_h * HEIGHT_RATIO
            --             local window_w_int = math.floor(window_w)
            --             local window_h_int = math.floor(window_h)
            --             local center_x = (screen_w - window_w) / 2
            --             local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            --             return {
            --                 border = 'rounded',
            --                 relative = 'editor',
            --                 row = center_y,
            --                 col = center_x,
            --                 width = window_w_int,
            --                 height = window_h_int,
            --             }
            --         end,
            --     },
            --     width = function()
            --         return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
            --     end,
            -- },
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
