return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    -- enabled = false,
    config = function()
        local function on_attach(bufnr)
            local api = require("nvim-tree.api")
            api.config.mappings.default_on_attach(bufnr)
            local opts = { buffer = bufnr }
            vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts)
            -- refocus on nvim-tree after opening
            vim.keymap.set("n", "<CR>", function()
                local node = api.tree.get_node_under_cursor()
                api.node.open.edit(node)
                api.tree.focus()
            end, opts)
        end
        require("nvim-tree").setup({
            -- disable_netrw = false and hijack_netrw = true should mean netrw
            -- can be used for following links as usual but not for its file browsing functionality
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = true, -- keep cursor on first letter of file when moving
            view = {
                -- side = 'right',
                -- preserve_window_proportions = true,
                -- signcolumn = 'no', -- doesn't seem to have effect
                float = {
                    enable = true,
                    quit_on_focus_loss = false,
                    open_win_config = {
                        relative = "editor",
                        border = "rounded",
                        width = 30,
                        height = 40,
                        row = 0,
                        col = 170, -- on right side; otherwise default is 1 for left side
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
                highlight_opened_files = "name",
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        git = {
                            unstaged = "✗", -- default
                            staged = "✓", -- default
                            unmerged = "", -- default
                            renamed = "R",
                            untracked = "U", -- e.g., new file; took default "unstaged" icon
                            deleted = "D",
                            ignored = "◌", -- default
                        },
                    },
                },
            },
            on_attach = on_attach,
        })
        vim.keymap.set("n", "<leader>pv", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle nvim-tree" }) -- set here since the plugin is loaded on this command
    end,
}
