return {
    "ibhagwan/fzf-lua",
    -- 'https://gitlab.com/ibhagwan/fzf-lua', -- Gitlab alt
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { "<leader>ff", "<leader>fs", "<leader>fl" },
    config = function()
        local fzf_lua = require("fzf-lua")
        local actions = require("fzf-lua.actions")
        fzf_lua.setup({
            defaults = {
                formatter = "path.dirname_first",
                winopts = {
                    height = 0.33,
                    width = 1,
                    row = 1,
                    col = 16,
                    border = "none",
                    backdrop = 100, -- don't dim buffers
                    preview = {
                        border = "none",
                        vertical = "down:40%",
                        horizontal = "right:40%",
                    },
                },
            },
            -- NOTE: for fzf only; can override the env var defaults
            -- fzf_colors = {
            -- },
            actions = {
                -- many pickers inherit from this table
                files = {
                    ["enter"] = actions.file_edit,
                },
            },
            files = {
                fd_opts = "--color=never --hidden --type f --type l --exclude .git",
                actions = {
                    -- NOTE: inherits from actions.files
                    ["ctrl-g"] = actions.toggle_ignore,
                },
            },
            grep = {
                prompt = "rg: ",
                input_prompt = "Grep for: ",
                hls = {
                    dir_part = "FzfLuaNormal",
                    file_part = "FzfLuaFzfPrompt",
                },
                rg_opts = "--column --line-number --color=always --smart-case --max-columns=4096 --hidden --no-ignore --follow --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/* -e",
            },
        })

        fzf_lua.register_ui_select()

        local map = require("winteragain.globals").map
        local opts = { silent = true }
        -- main keymaps
        map("n", "<leader>ff", fzf_lua.files, opts, "Search files")
        map("n", "<leader>fl", fzf_lua.buffers, opts, "Search buffers")
        map("n", "<leader>hl", fzf_lua.highlights, opts, "Search hl groups")
        map("n", "<leader>fc", fzf_lua.colorschemes, opts, "Search colorschemes")
        map("n", "<leader>fk", fzf_lua.keymaps, opts, "Search keymaps")
        map("n", "<leader>fd", fzf_lua.diagnostics_document, opts, "Search buffer diagnostics")
        map("n", "<leader>fD", fzf_lua.diagnostics_workspace, opts, "Search workspace diagnostics")

        map("n", "<leader>fq", fzf_lua.quickfix, opts, "Search quickfix list")
        map("n", "<leader>fj", fzf_lua.jumps, opts, "Search jumps")
        map("n", "<leader>fa", fzf_lua.autocmds, opts, "Search autocommands")
        map("n", "<leader>fh", fzf_lua.helptags, opts, "Search help tags")
        map("n", "<leader>fr", fzf_lua.registers, opts, "Search registers")

        map("n", "<leader>fgs", fzf_lua.git_status, opts, "Search git status")
        map("n", "<leader>fgb", fzf_lua.git_bcommits, opts, "Search buf commit log")
        map("n", "<leader>fgc", fzf_lua.git_commits, opts, "Search proj git commit log")

        map("n", "<leader>fs", function()
            require("fzf-lua").live_grep({ exec_empty_query = true })
        end, opts, "Live grep")
        map("n", "<leader>/", fzf_lua.lgrep_curbuf, opts, "Find in current buffer")

        -- NOTES
        local notes_dir = "~/Documents/notebook"
        map("n", "<leader>fn", function()
            fzf_lua.files({ cwd = notes_dir, fd_opts = "--color=never --type f -e md --hidden --follow" })
        end, opts, "Search notes")
        map("n", "<leader>ns", function()
            fzf_lua.live_grep({ cwd = notes_dir, exec_empty_query = true })
        end, opts, "Live grep notes")
    end,
}
