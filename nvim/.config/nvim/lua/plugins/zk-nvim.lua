return {
    "zk-org/zk-nvim",
    lazy = true,
    -- enabled = false,
    dev = true,
    keys = {
        "<leader>nn",
        "<leader>fn",
        "<leader>ns",
    },
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notebook/*.md",
    },
    config = function()
        require("zk").setup({
            picker = "fzf_lua",
            lsp = {
                config = {
                    cmd = { "zk", "lsp" },
                    -- cmd = { "zk", "lsp", "--log", "/tmp/zk-lsp.log" },
                    name = "zk",
                    on_attach = function(client, bufnr)
                        -- NOTE: disable to avoid sending another request alongside marksman
                        -- which would result in duplicate entries on getting defn
                        client.server_capabilities.definitionProvider = false
                    end,
                },
            },
            auto_attach = {
                enabled = true,
                filetypes = { "markdown" },
            },
        })

        local map = require("winter-again.globals").map
        local opts = { silent = true }
        local zk = require("zk")
        local zk_cmds = require("zk.commands")

        -- search notes from anywhere by specifying notebook_path
        map("n", "<leader>fn", function()
            zk_cmds.get("ZkNotes")({ notebook_path = "/home/winteragain/Documents/notebook" })
        end, opts, "Search notes by title")

        map("n", "<leader>ns", function()
            require("fzf-lua").live_grep({
                prompt = "rg notes: ",
                exec_empty_query = true,
                cwd = "~/Documents/notebook",
                rg_opts = [[--type=md --smart-case --line-number --column --color=always --colors=line:fg:green --colors=column:fg:yellow --max-columns=4096]],
            })
        end, opts, "Search notes with ripgrep")

        -- TODO: figure out how to add ctrl-q keymap for adding all to qflist
        -- NOTE: chaining commands breaks when values in options table aren't valid for both commands
        -- For example, sort = "note-count" only works for tags picker
        -- NOTE: search for notes with any one of many tags
        zk_cmds.add("ZkTagsOr", function(options)
            options = options or {}

            local tag_sort_options = {}
            local edit_sort_options = {}
            if options.sort ~= nil and vim.tbl_contains(options.sort, "note-count") then
                if #options.sort == 1 then
                    tag_sort_options = options.sort
                else
                    for _, v in ipairs(options.sort) do
                        if v == "note-count" then
                            table.insert(tag_sort_options, v)
                        else
                            table.insert(edit_sort_options, v)
                        end
                    end
                end
            end

            local tags_options = vim.tbl_extend("force", options, { sort = tag_sort_options })
            zk.pick_tags(tags_options, { title = "Zk tags (using OR)", multi_select = true }, function(tags)
                tags = vim.tbl_map(function(v)
                    return v.name
                end, tags)
                local tags_or = table.concat(tags, " OR ") -- use OR, otherwise implicitly AND
                local edit_options = vim.tbl_extend("force", options, { tags = { tags_or }, sort = edit_sort_options })
                local actions = require("fzf-lua.actions")

                local function path_from_selected(selected)
                    local delimiter = "\x01"
                    return vim.tbl_map(function(line)
                        return string.match(line, "([^" .. delimiter .. "]+)")
                    end, selected)
                end

                zk.edit(edit_options, {
                    title = ("Zk Notes for tag(s) { %s }"):format(tags_or),
                    fzf_lua = {
                        actions = {
                            ["ctrl-q"] = function(selected, _options)
                                local entries = path_from_selected(selected)
                                actions.file_sel_to_qf(entries, _options)
                            end,
                        },
                    },
                })
            end)
        end)
        map("n", "<leader>nt", "<cmd>ZkTagsOr { sort = { 'note-count' } }<CR>", opts, "Search for notes with tags")

        -- NOTE: zk can't detect my style of links
        -- map("n", "<leader>nl", function()
        --     zk_cmd.get("ZkLinks")()
        -- end, opts, "Search links")
        -- map("n", "<leader>nb", function()
        --     zk_cmd.get("ZkBacklinks")()
        -- end, opts, "Search backlinks")

        zk_cmds.add("ZkTempl", function(options)
            options = options or {}
            -- NOTE: maybe wrong, but seems that I have to specify user command args as table like
            -- ZkTempl { args = { ... } }. The args part is my own arbitrary choice.
            if options.args == nil then
                return
            elseif #options.args > 1 then
                return
            end

            local cmd = options.args[1]
            if cmd == "default" or cmd == "def" then
                zk_cmds.get("ZkNew")({ inline = true })
            elseif cmd == "meeting" or cmd == "meetings" or cmd == "meet" then
                zk_cmds.get("ZkNew")({ inline = true, group = "meetings" })
            elseif cmd == "leetcode" or cmd == "leet" or cmd == "lc" then
                zk_cmds.get("ZkNew")({ inline = true, template = "leetcode-templ.md" })
            end
        end)

        -- TODO: use file name for title in template?
        local function insert_templ()
            local templates = vim.fs.normalize("~/Documents/notebook/.zk/templates")
            local suffix = "-templ.md"
            local choices = {}
            for name, _ in vim.fs.dir(templates) do
                local templ = name:sub(1, #name - #suffix)
                table.insert(choices, templ)
            end

            vim.ui.select(choices, {
                prompt = "Template: ",
            }, function(choice)
                vim.cmd(string.format("ZkTempl { args = { '%s' }}", choice))
            end)
        end
        map("n", "<leader>ni", insert_templ, opts, "Insert note template")

        local function create_note_with_templ()
            vim.ui.input({ prompt = "New note file name: " }, function(file_name)
                if file_name == nil then
                    return
                end

                -- replace "-" with spaces, remove ".md" if exists, and ensure first letter capitalized
                file_name = file_name:gsub(".md", "")
                local title = file_name:gsub("-", " "):gsub("^%l", string.upper)

                local templates = vim.fs.normalize("~/Documents/notebook/.zk/templates")
                local suffix = "-templ.md"
                local choices = {}
                for name, _ in vim.fs.dir(templates) do
                    local templ = name:sub(1, #name - #suffix)
                    table.insert(choices, templ)
                end

                vim.ui.select(choices, {
                    prompt = "Template: ",
                }, function(choice)
                    -- TODO: figure out how to create notes even from outside of notebook dir
                    -- Likely requires global zk config file
                    if choice == "default" or choice == "def" then
                        zk_cmds.get("ZkNew")({
                            title = title,
                            filenameStem = file_name,
                            dir = "notes",
                        })
                    elseif choice == "meeting" or choice == "meetings" or choice == "meet" then
                        -- TODO: ideally would get rid of this and just remember to not include a date when giving
                        -- file name
                        if file_name:match("^%d%d%d%d%-%d%d%-%d%d%-") ~= nil then
                            title = file_name:sub(12):gsub("-", " ")
                        end
                        zk_cmds.get("ZkNew")({
                            title = title,
                            filenameStem = file_name,
                            dir = "meetings",
                            group = "meetings",
                        })
                    elseif choice == "leetcode" or choice == "leet" or choice == "lc" then
                        zk_cmds.get("ZkNew")({
                            title = title,
                            filenameStem = file_name,
                            dir = "notes",
                            template = "leetcode-templ.md",
                        })
                    end
                end)
            end)
        end
        map("n", "<leader>nn", create_note_with_templ, opts, "Create note from chosen template")
    end,
}
