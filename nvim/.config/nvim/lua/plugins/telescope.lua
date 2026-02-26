return {
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x', -- this is supp to be the stable branch
        dependencies = {
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        config = function()
            -- local actions = require('telescope.actions')
            local telescope_config = require('telescope.config')
            local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
            -- allow search in hidden files
            table.insert(vimgrep_arguments, '--hidden')
            -- leave this out of it
            table.insert(vimgrep_arguments, '--glob')
            table.insert(vimgrep_arguments, '!**/.git/*')

            table.insert(vimgrep_arguments, '--glob')
            table.insert(vimgrep_arguments, '!**/.venv/*')

            table.insert(vimgrep_arguments, '--glob')
            table.insert(vimgrep_arguments, '!**/node_modules/*')

            require('telescope').setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                    sorting_strategy = 'ascending',
                    layout_config = {
                        horizontal = {
                            prompt_position = 'top',
                        },
                    },
                },
                pickers = {
                    find_files = {
                        -- --files = print files ripgrep would search but don't actually search
                        -- --hidden = allow hidden files/directories
                        -- ignore .git dir
                        -- ignore .venv dir (useful if we haven't specified it in a .gitignore yet)
                        find_command = {
                            'rg',
                            '--files',
                            '--hidden',
                            '-g',
                            '!**/.git/*',
                            '-g',
                            '!**/.venv/*',
                            '-g',
                            '!**/node_modules/*',
                        },
                    },
                },
                extensions = {
                    undo = {
                        use_delta = true,
                        side_by_side = true,
                        layout_strategy = 'vertical',
                        layout_config = {
                            preview_height = 0.8,
                        },
                    },
                    file_browser = {
                        hijack_netrw = true,
                    },
                },
            })
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('undo')
            require('telescope').load_extension('persisted')
            require('telescope').load_extension('file_browser')
            -- require('telescope').load_extension('harpoon')

            local builtin = require('telescope.builtin')
            -- use '<leader>ff' to find among ALL files; respects .gitignore
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { silent = true })
            -- use '<leader>fg' to find among git files; again respects .gitignore
            vim.keymap.set('n', '<leader>fgc', builtin.git_commits, { silent = true })
            vim.keymap.set('n', '<leader>fgb', builtin.git_bcommits, { silent = true })
            vim.keymap.set('n', '<leader>fgs', builtin.git_status, { silent = true })
            -- search for string in current working dir
            vim.keymap.set('n', '<leader>fs', builtin.live_grep, { silent = true })
            -- search within current buffer
            vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { silent = true })
            -- search registers
            vim.keymap.set('n', '<leader>fr', builtin.registers, { silent = true })
            -- search open buffers in current neovim instance
            vim.keymap.set('n', '<leader>fl', builtin.buffers, { silent = true })
            -- search diagnostics for current buffer
            vim.keymap.set('n', '<leader>fd', function()
                builtin.diagnostics({ bufnr = 0 })
            end, { silent = true })
            -- search diagnostics for entire workspace
            vim.keymap.set('n', '<leader>fD', builtin.diagnostics, { silent = true })
            -- search keymaps
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { silent = true })
            -- search highlights
            vim.keymap.set('n', '<leader>fh', builtin.highlights, { silent = true })
            -- search colorscheme
            vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { silent = true })
            --search jumplist
            vim.keymap.set('n', '<leader>fj', builtin.jumplist, { silent = true })
            -- extensions
            vim.keymap.set('n', '<leader>fu', '<cmd>Telescope undo<CR>', { silent = true })
            vim.keymap.set('n', '<leader>fp', '<cmd>Telescope persisted<CR>', { silent = true })
            vim.keymap.set('n', '<leader>fv', '<cmd>Telescope file_browser<CR>', { silent = true })
        end,
    },
}
