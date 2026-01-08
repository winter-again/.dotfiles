--- @diagnostic disable: missing-fields
return {
    "ibhagwan/fzf-lua",
    -- "https://gitlab.com/ibhagwan/fzf-lua", -- Gitlab alt
    dependencies = { "nvim-mini/mini.icons" },
    event = "VimEnter",
    config = function()
        local fzf_lua = require("fzf-lua")
        local actions = require("fzf-lua.actions")
        fzf_lua.setup({
            defaults = {
                formatter = "path.dirname_first",
            },
            winopts = {
                height = 0.33,
                width = 1,
                row = 1, -- row position 1 = bottom
                col = 0, -- col position 0 = left; only relevant if width < 1.0
                border = "none",
                backdrop = 100, -- don't dim buffer on search
                preview = {
                    border = "single",
                    vertical = "down:40%",
                    horizontal = "right:45%",
                },
            },
            hls = {
                -- can override hl groups here
            },
            -- NOTE: if set, these override settings from fzf env vars
            -- fzf_opts = { },
            -- fzf_colors = { },
            actions = {
                -- NOTE: Many pickers inherit from this table; must explicitly define actions here
                -- b/c it doesn't get merged with global defaults
                files = {
                    ["default"] = actions.file_edit_or_qf,
                    -- ["default"] = actions.file_edit,
                    ["ctrl-h"] = actions.file_split,
                    ["ctrl-v"] = actions.file_vsplit,
                    ["ctrl-q"] = actions.file_sel_to_qf,
                    ["ctrl-a"] = { fn = actions.file_sel_to_qf, prefix = "select-all" },
                    ["ctrl-g"] = actions.toggle_ignore,
                },
            },
            files = {
                -- fd respects .gitignore, but still specify some files to ignore in case
                -- no .gitignore present
                fd_opts = "--type file --follow --hidden --exclude .git --exclude .venv --exclude node_modules --color never",
                git_icons = false,
                file_icons = true,
                -- NOTE: inherits from actions.files
                -- actions = {},
            },
            grep = {
                prompt = "rg: ",
                -- rightfully ignores .ripgreprc
                rg_opts = [[--smart-case --line-number --column --color=always --colors=line:fg:green --colors=column:fg:yellow --max-columns=4096 --glob="!{.git,.venv,node_modules}/*" --glob="!*.csv"]],
                rg_glob = true,
                hidden = true,
                follow = true,
                glob_flag = "--iglob",
                glob_separator = "%s%-%-",
                -- NOTE: grep.files inherits from actions.files, but it seems to have its own defaults
                -- so I have to set ctrl-g again
                actions = {
                    ["ctrl-g"] = actions.toggle_ignore,
                    ["ctrl-f"] = actions.grep_lgrep, -- switch between fuzzy and regex search
                },
            },
            colorschemes = {
                winopts = { height = 0.33 },
            },
        })

        fzf_lua.register_ui_select()

        local map = require("winter-again.globals").map
        local opts = { silent = true }

        map("n", "<leader>ff", fzf_lua.files, opts, "Search files")
        map("n", "<leader>fl", fzf_lua.buffers, opts, "Search buffers")
        map("n", "<leader>fs", function()
            require("fzf-lua").live_grep({ exec_empty_query = true })
        end, opts, "Live grep")
        map("n", "<leader>/", fzf_lua.lgrep_curbuf, opts, "Find in current buffer")

        map("n", "z=", fzf_lua.spell_suggest, opts, "Spelling suggestions")

        map("n", "<leader>hl", fzf_lua.highlights, opts, "Search hl groups")
        map("n", "<leader>fc", fzf_lua.colorschemes, opts, "Search colorschemes")
        map("n", "<leader>fk", fzf_lua.keymaps, opts, "Search keymaps")
        map("n", "<leader>fd", fzf_lua.diagnostics_document, opts, "Search buffer diagnostics")
        map("n", "<leader>fD", fzf_lua.diagnostics_workspace, opts, "Search workspace diagnostics")

        map("n", "<leader>fh", fzf_lua.helptags, opts, "Search help tags")
        map("n", "<leader>fq", fzf_lua.quickfix, opts, "Search quickfix list")
        map("n", "<leader>fa", fzf_lua.autocmds, opts, "Search autocommands")
        map("n", "<leader>fr", fzf_lua.registers, opts, "Search registers")

        map("n", "<leader>fgs", fzf_lua.git_status, opts, "Search git status")
        map("n", "<leader>fgb", fzf_lua.git_bcommits, opts, "Search buf commit log")
        map("n", "<leader>fgc", fzf_lua.git_commits, opts, "Search proj git commit log")
    end,
}
