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
                -- hls = {
                --     dir_part = "FzfLuaNormal",
                --     file_part = "FzfLuaFzfPrompt",
                -- },
            },
            -- NOTE: for fzf only; can override the env var defaults
            -- fzf_colors = {
            -- },
            files = {
                -- fd_opts = "--color=always --type f --type l --hidden --follow",
                fd_opts = "--color=never --hidden --type f --type l --exclude .git",
                actions = {
                    -- ["default"] = actions.file_edit,
                    ["enter"] = actions.file_edit_or_qf,
                    ["ctrl-g"] = actions.toggle_ignore,
                },
            },
            grep = {
                prompt = "rg❯ ",
                input_prompt = "Grep for❯ ",
                hls = {
                    dir_part = "FzfLuaNormal",
                    file_part = "FzfLuaFzfPrompt",
                },
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --no-ignore --follow --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/* -e",
                -- rg_glob = true,
            },
        })

        local function map(mode, lhs, rhs, opts, desc)
            opts = opts or {}
            opts.desc = desc
            vim.keymap.set(mode, lhs, rhs, opts)
        end
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
            require("fzf-lua").live_grep({
                exec_empty_query = true,
                -- cmd = "rg --column --line-number --hidden --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/*",
            })
        end, opts, "Live grep")
        map("n", "<leader>/", fzf_lua.lgrep_curbuf, opts, "Find in current buffer")
    end,
}
