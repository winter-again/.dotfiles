return {
    "zk-org/zk-nvim",
    lazy = true,
    enabled = false,
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
                    name = "zk",
                    on_attach = function(client, bufnr)
                        -- NOTE: disable to avoid sending another request alongside marksman
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
        local zk_cmd = require("zk.commands")

        map("n", "<leader>nt", function()
            zk_cmd.get("ZkTags")({ sort = { "note-count" } })
        end, opts, "Search tags")
        map("n", "<leader>nl", function()
            zk_cmd.get("ZkLinks")()
        end, opts, "Search links")
        map("n", "<leader>nb", function()
            zk_cmd.get("ZkBacklinks")()
        end, opts, "Search backlinks")

        vim.api.nvim_create_user_command("ZkTempl", function(args)
            local cmd = args.fargs[1]
            if cmd == "default" or cmd == "def" then
                zk_cmd.get("ZkNew")({ inline = true })
            elseif cmd == "meeting" or cmd == "meetings" or cmd == "meet" then
                zk_cmd.get("ZkNew")({ inline = true, group = "meetings" })
            elseif cmd == "leetcode" or cmd == "leet" or cmd == "lc" then
                zk_cmd.get("ZkNew")({ inline = true, group = "leetcode" })
            end
        end, {
            nargs = 1,
            complete = function()
                local templates = vim.fs.normalize("~/Documents/notebook/.zk/templates")
                local suffix = "-templ.md"
                local choices = {}
                for name, _ in vim.fs.dir(templates) do
                    local templ = name:sub(1, #name - #suffix)
                    table.insert(choices, templ)
                end

                return choices
            end,
            desc = "Insert template into current note",
        })

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
                vim.cmd("ZkTempl " .. choice)
            end)
        end
        map("n", "<leader>ni", insert_templ, opts, "Insert note template")

        local function create_note_with_templ()
            vim.ui.input({ prompt = "Note file name: " }, function(file_name)
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
                    if choice == "default" or choice == "def" then
                        zk_cmd.get("ZkNew")({
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
                        zk_cmd.get("ZkNew")({
                            title = title,
                            filenameStem = file_name,
                            dir = "meetings",
                            group = "meetings",
                        })
                    elseif choice == "leetcode" or choice == "leet" or choice == "lc" then
                        zk_cmd.get("ZkNew")({
                            title = title,
                            filenameStem = file_name,
                            dir = "notes/leetcode",
                            group = "leetcode",
                        })
                    end
                end)
            end)
        end
        map("n", "<leader>nn", create_note_with_templ, opts, "Create note from chosen template")
    end,
}
