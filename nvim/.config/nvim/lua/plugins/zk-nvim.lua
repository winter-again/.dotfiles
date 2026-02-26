return {
    "zk-org/zk-nvim",
    -- enabled = false,
    lazy = true,
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

        local map = require("winteragain.globals").map
        local opts = { silent = true }
        local zk_cmd = require("zk.commands")

        map("n", "<leader>nn", function()
            zk_cmd.get("ZkNew")()
        end, opts, "New note with default template")
        map("n", "<leader>nm", function()
            zk_cmd.get("ZkNew")({ dir = "meetings", group = "meetings" })
        end, opts, "New meeting note")

        map("n", "<leader>nt", function()
            zk_cmd.get("ZkTags")({ sort = { "note-count" } })
        end, opts, "Search tags")
        map("n", "<leader>nl", function()
            zk_cmd.get("ZkLinks")()
        end, opts, "Search links")
        map("n", "<leader>nb", function()
            zk_cmd.get("ZkBacklinks")()
        end, opts, "Search backlinks")

        -- create custom user command since Zk capability doesn't pass the args through
        vim.api.nvim_create_user_command("ZkTempl", function(args)
            local cmd = args.fargs[1]
            if cmd == "meeting" or cmd == "meetings" or cmd == "meet" then
                zk_cmd.get("ZkNew")({ inline = true, group = "meetings" })
            elseif cmd == "leetcode" or cmd == "leet" or cmd == "lc" then
                zk_cmd.get("ZkNew")({ inline = true, group = "leetcode" })
            end
        end, {
            nargs = 1,
            complete = function()
                local templates = vim.fs.normalize("~/Documents/notebook/.zk/templates")
                local choices = {}
                for name, _ in vim.fs.dir(templates) do
                    local suffix = "-templ.md"
                    local templ = name:sub(1, #name - #suffix)
                    table.insert(choices, templ)
                end

                return choices
            end,
            desc = "Create note based on template",
        })
    end,
}
