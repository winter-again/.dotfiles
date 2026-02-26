return {
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x', -- this is supp to be the stable branch
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'debugloop/telescope-undo.nvim',
            },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable('make') == 1
                end,
            },
            {
                'nvim-telescope/telescope-ui-select.nvim',
            },
            -- {
            --     'paopaol/telescope-git-diffs.nvim',
            --     dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
            -- },
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

            -- workaround for opening multiple files
            -- from: https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1679797700
            local function select_one_or_multi(prompt_bufnr)
                local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                    require('telescope.actions').close(prompt_bufnr)
                    for _, j in pairs(multi) do
                        if j.path ~= nil then
                            vim.cmd(string.format('%s %s', 'edit', j.path))
                        end
                    end
                else
                    require('telescope.actions').select_default(prompt_bufnr)
                end
            end

            -- from:
            -- https://github.com/nvim-telescope/telescope.nvim/issues/2874#issuecomment-1900967890
            -- use <C-h> to toggle finding on .gitignore'd files
            local function my_ff(opts, no_ignore)
                opts = opts or {}
                no_ignore = vim.F.if_nil(no_ignore, false)
                opts.attach_mappings = function(_, map)
                    map({ 'n', 'i' }, '<C-h>', function(prompt_bufnr) -- <C-h> to toggle modes
                        local prompt = require('telescope.actions.state').get_current_line()
                        require('telescope.actions').close(prompt_bufnr)
                        no_ignore = not no_ignore
                        my_ff({ default_text = prompt }, no_ignore)
                    end)
                    return true
                end

                if no_ignore then
                    opts.no_ignore = true
                    opts.hidden = true
                    opts.prompt_title = 'Find Files <ALL>'
                    require('telescope.builtin').find_files(opts)
                else
                    opts.prompt_title = 'Find Files'
                    require('telescope.builtin').find_files(opts)
                end
            end

            -- local fb_actions = require('telescope._extensions.file_browser.actions')
            require('telescope').setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                    sorting_strategy = 'ascending',
                    layout_config = {
                        horizontal = {
                            prompt_position = 'top',
                        },
                    },
                    mappings = {
                        i = {
                            ['<CR>'] = select_one_or_multi,
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
                            '--glob',
                            '!**/.git/*',
                            '--glob',
                            '!**/.venv/*',
                            '--glob',
                            '!**/node_modules/*',
                        },
                    },
                },
                extensions = {
                    -- git_diffs = {
                    --     git_command = { 'git', 'log', '--oneline', '--decorate', '--all', '.' },
                    -- },
                    undo = {
                        use_delta = true,
                        side_by_side = true,
                        layout_strategy = 'vertical',
                        layout_config = {
                            preview_height = 0.5,
                        },
                    },
                    file_browser = {
                        hijack_netrw = true,
                        -- hidden = { file_browser = true, folder_browser = true },
                        respect_gitignore = false,
                        depth = 4,
                        autodepth = 4,
                        -- mappings = {
                        --     -- defaults; just for ref
                        --     ['i'] = {
                        --         ['<C-h'] = fb_actions.toggle_hidden,
                        --     },
                        -- },
                    },
                },
            })
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('ui-select')
            require('telescope').load_extension('undo')
            require('telescope').load_extension('file_browser')
            -- require('telescope').load_extension('git_diffs')
            -- require('telescope').load_extension('harpoon')

            local builtin = require('telescope.builtin')
            local opts = { silent = true }
            -- vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
            Map('n', '<leader>fn', function()
                builtin.find_files({ cwd = vim.fn.stdpath('config') })
            end, opts, 'Search nvim config')
            Map('n', '<leader>fmf', my_ff, opts, 'Custom file search with multi-select support')
            -- git
            Map('n', '<leader>fgs', builtin.git_status, opts, 'Search files with diff in preview')
            Map(
                'n',
                '<leader>fgc',
                builtin.git_bcommits,
                opts,
                'Search git commits for current buf with diff in preview'
            )
            Map('n', '<leader>fgb', builtin.git_branches, opts, 'Search git branches')
            -- view diffs between commits and open them with diffview.nvim
            -- vim.keymap.set('n', '<leader>fgc', '<cmd>Telescope git_diffs diff_commits<CR>', opts)
            -- treesitter symbols
            vim.keymap.set('n', '<leader>ft', builtin.treesitter, opts)
            -- search for string in current working dir
            vim.keymap.set('n', '<leader>fs', builtin.live_grep, opts)
            -- search within current buffer
            vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, opts)
            -- search registers
            vim.keymap.set('n', '<leader>fr', builtin.registers, opts)
            -- search open buffers in current neovim instance
            vim.keymap.set('n', '<leader>fl', builtin.buffers, opts)
            -- search diagnostics for current buffer
            vim.keymap.set('n', '<leader>fd', function()
                builtin.diagnostics({ bufnr = 0 })
            end, opts)
            -- search diagnostics for entire workspace
            vim.keymap.set('n', '<leader>fD', builtin.diagnostics, opts)
            -- search keymaps
            -- vim.keymap.set('n', '<leader>fk', builtin.keymaps, opts)
            -- search highlights
            vim.keymap.set('n', '<leader>hl', builtin.highlights, opts)
            -- search help tags
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
            -- search colorscheme
            -- vim.keymap.set('n', '<leader>fc', builtin.colorscheme, opts)
            -- autocommnds
            vim.keymap.set('n', '<leader>fa', builtin.autocommands, opts)
            -- search jumplist
            vim.keymap.set('n', '<leader>fj', builtin.jumplist, opts)
            -- quickfix list
            vim.keymap.set('n', '<leader>fq', builtin.quickfix, opts)
            -- extensions
            vim.keymap.set('n', '<leader>fu', '<cmd>Telescope undo<CR>', opts)
            vim.keymap.set('n', '<leader>fp', '<cmd>Telescope persisted<CR>', opts)
            vim.keymap.set('n', '<leader>fv', '<cmd>Telescope file_browser<CR>', opts)
        end,
    },
}
