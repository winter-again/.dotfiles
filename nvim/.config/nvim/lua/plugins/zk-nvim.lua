return {
    "zk-org/zk-nvim",
    lazy = true,
    -- dev = true,
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
        -- local zk = require("zk")
        local zk_cmds = require("zk.commands")

        map("n", "<leader>fn", function()
            zk_cmds.get("ZkNotes")({ notebook_path = "/home/winteragain/Documents/notebook" })
        end, opts, "Search notes by title from anwhere")
        map("n", "<leader>nt", function()
            zk_cmds.get("ZkTags")({ multi_select_strategy = "OR" })
        end, opts, "Search for notes with tags using OR")
        map("n", "<leader>ns", function()
            require("fzf-lua").live_grep({
                prompt = "rg notes: ",
                exec_empty_query = true,
                cwd = "~/Documents/notebook",
                rg_opts = [[--type=md --smart-case --line-number --column --color=always --colors=line:fg:green --colors=column:fg:yellow --max-columns=4096]],
            })
        end, opts, "Search notes with ripgrep")

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

        -- TODO: need to fix date handling in meeting note titles -> simplify so it's easier to remember what format I need
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
