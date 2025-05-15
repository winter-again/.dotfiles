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
                    -- on_attach = function()
                    --     vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
                    --     vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
                    -- end,
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
        -- map("n", "<leader>zn", function()
        --     zk_cmd.get("ZkNotes")({ sort = { "modified" } })
        -- end, opts, "Search notes")
        map("n", "<leader>nt", function()
            zk_cmd.get("ZkTags")({ sort = { "note-count" } })
        end, opts, "Search tags")
        map("n", "<leader>nl", function()
            zk_cmd.get("ZkLinks")()
        end, opts, "Search links")
        map("n", "<leader>nb", function()
            zk_cmd.get("ZkBacklinks")()
        end, opts, "Search backlinks")
    end,
}
