return {
    "ibhagwan/fzf-lua",
    -- 'https://gitlab.com/ibhagwan/fzf-lua', -- Gitlab alt
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    keys = { "<leader>ff", "<leader>fs", "<leader>fl" },
    config = function()
        local fzf_lua = require("fzf-lua")
        fzf_lua.setup({
            fzf_colors = true,
            winopts = {
                border = "none",
            },
            -- open multiple files by marking w/ tab
            files = {
                actions = {
                    ["default"] = require("fzf-lua.actions").file_edit,
                },
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
            require("fzf-lua").live_grep_glob({
                exec_empty_query = true,
                cmd = "rg --column --line-number --hidden --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/*",
            })
        end, opts, "Live grep")
        map("n", "<leader>/", fzf_lua.lgrep_curbuf, opts, "Find in current buffer")
    end,
}
