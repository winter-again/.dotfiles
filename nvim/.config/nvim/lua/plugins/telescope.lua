return {
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x", -- this is supp to be the stable branch
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            {
                "nvim-telescope/telescope-ui-select.nvim",
            },
        },
        config = function()
            -- workaround for opening multiple files -- can use fzf-lua instead
            -- from:https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1679797700
            -- now, can map <CR> to select_one_or_multi
            local function select_one_or_multi(prompt_bufnr)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local multi = picker:get_multi_selection()

                if not vim.tbl_isempty(multi) then
                    -- will also add current selection to multi list
                    -- even if not marked
                    local sel_row = picker:get_selection_row()
                    picker:add_selection(sel_row)
                    local new_multi = picker:get_multi_selection()

                    require("telescope.actions").close(prompt_bufnr)
                    for _, j in pairs(new_multi) do
                        if j.path ~= nil then
                            vim.cmd(string.format("%s %s", "edit", j.path))
                        end
                    end
                else
                    require("telescope.actions").select_default(prompt_bufnr)
                end
            end

            -- from https://github.com/nvim-telescope/telescope.nvim/issues/2874#issuecomment-1900967890
            -- use <C-g> to toggle finding on .gitignore'd files
            local function custom_ff(opts, no_ignore)
                opts = opts or {}
                no_ignore = vim.F.if_nil(no_ignore, false)
                opts.attach_mappings = function(_, map)
                    map({ "n", "i" }, "<C-h>", function(prompt_bufnr)
                        local prompt = require("telescope.actions.state").get_current_line()
                        require("telescope.actions").close(prompt_bufnr)
                        no_ignore = not no_ignore
                        custom_ff({ default_text = prompt }, no_ignore)
                    end)
                    return true
                end

                if no_ignore then
                    opts.no_ignore = true
                    opts.hidden = true
                    opts.prompt_title = "Find Files <ALL>"
                    require("telescope.builtin").find_files(opts)
                else
                    opts.prompt_title = "Find Files"
                    require("telescope.builtin").find_files(opts)
                end
            end

            local actions = require("telescope.actions")
            local fb_actions = require("telescope._extensions.file_browser.actions")

            -- NOTE: define custom action for opening Trouble qflist buffer
            local transform_mod = require("telescope.actions.mt").transform_mod
            local trouble = require("trouble")
            local mod = {
                open_trouble_qflist = function(prompt_bufnr)
                    trouble.open("qflist")
                end,
            }
            mod = transform_mod(mod)

            require("telescope").setup({
                defaults = {
                    border = false,
                    winblend = 0, -- opaque
                    -- command for live_grep and grep_string
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob",
                        "!**/.git/*",
                        "--glob",
                        "!**/.venv/*",
                        "--glob",
                        "!**/node_modules/*",
                    },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                        },
                    },
                    mappings = {
                        i = {
                            ["<C-q>"] = actions.send_to_qflist + mod.open_trouble_qflist,
                            ["<M-q>"] = false,
                            ["<C-s>"] = actions.send_selected_to_qflist + mod.open_trouble_qflist,
                            ["<CR>"] = select_one_or_multi,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        -- --files = print files ripgrep would search
                        -- --hidden = allow hidden files/directories
                        -- ignore .git dir
                        -- ignore .venv dir (useful if we haven't specified it in a .gitignore yet)
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",
                            "--glob",
                            "!**/.git/*",
                            "--glob",
                            "!**/.venv/*",
                            "--glob",
                            "!**/node_modules/*",
                        },
                    },
                },
                extensions = {
                    -- defaults; only here for ref
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mod = "smart_case",
                    },
                    file_browser = {
                        hijack_netrw = true,
                        -- whether to show hidden files or not
                        hidden = { file_browser = true, folder_browser = true },
                        depth = 4,
                        autodepth = 4,
                        mappings = {
                            ["i"] = {
                                ["<C-h>"] = fb_actions.toggle_hidden,
                            },
                        },
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                    -- git_diffs = {
                    --     git_command = { 'git', 'log', '--oneline', '--decorate', '--all', '.' },
                    -- },
                    undo = {
                        use_delta = true,
                        -- use_delta must be true to use side_by_side
                        side_by_side = false, -- may contradict .gitconfig delta settings
                        layout_strategy = "vertical",
                        layout_config = {
                            preview_height = 0.6,
                        },
                    },
                },
            })

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("ui-select")
            require("telescope").load_extension("undo")
            -- require('telescope').load_extension('git_diffs')
            -- require('telescope').load_extension('harpoon')

            local builtin = require("telescope.builtin")
            local function map(mode, lhs, rhs, opts, desc)
                opts = opts or {}
                opts.desc = desc
                vim.keymap.set(mode, lhs, rhs, opts)
            end
            local opts = { silent = true }

            map("n", "<leader>ff", custom_ff, opts, "Search files")
            -- map('n', '<leader>ff', builtin.find_files, opts, 'Search files')
            map("n", "<leader>fl", builtin.buffers, opts, "Search buffers")
            map("n", "<leader>hl", builtin.highlights, opts, "Search hl groups")
            map("n", "<leader>fc", function()
                builtin.colorscheme({ enable_preview = true, ignore_builtins = true })
            end, opts, "Search colorschemes")
            map("n", "<leader>fk", builtin.keymaps, opts, "Search keymaps")
            map("n", "<leader>fd", function()
                builtin.diagnostics({ bufnr = 0 })
            end, opts, "Search buffer diagnostics")
            map("n", "<leader>fD", builtin.diagnostics, opts, "Search workspace diagnostics")
            map("n", "<leader>fq", builtin.quickfix, opts, "Search quickfix")
            map("n", "<leader>fj", builtin.jumplist, opts, "Search jumplist")
            map("n", "<leader>fa", builtin.autocommands, opts, "Search autocmds")
            map("n", "<leader>fh", builtin.help_tags, opts, "Search help tags")
            map("n", "<leader>fr", builtin.registers, opts, "Search registers")

            -- search for string in current working dir
            map("n", "<leader>fs", builtin.live_grep, opts, "Live grep")
            -- search within current buffer
            map("n", "<leader>/", builtin.current_buffer_fuzzy_find, opts, "Search curr. buf")
            -- treesitter symbols
            -- map("n", "<leader>ft", builtin.treesitter, opts, "Search treesitter symbols")
            map("n", "<leader>fn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, opts, "Search nvim config")

            -- git
            map("n", "<leader>fgs", builtin.git_status, opts, "Search files with diff in preview")
            map("n", "<leader>fgb", builtin.git_branches, opts, "Search git branches")
            -- map('n', '<leader>fgc', builtin.git_commits, opts, 'Search git commits with diff in preview')
            map("n", "<leader>fgc", builtin.git_bcommits, opts, "Search current buf git commits with diff in preview")

            -- view diffs between commits and open them with diffview.nvim
            -- vim.keymap.set('n', '<leader>fgc', '<cmd>Telescope git_diffs diff_commits<CR>', opts)

            -- extensions
            map("n", "<leader>fu", "<cmd>Telescope undo<CR>", opts, "Telescope undo")
            map("n", "<leader>fv", "<cmd>Telescope file_browser<CR>", opts, "Telescope file browser")
        end,
    },
}
