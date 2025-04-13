return {
    "zk-org/zk-nvim",
    enabled = false,
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
                    on_attach = function()
                        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
                        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
                    end,
                },
            },
            auto_attach = {
                enabled = true,
                filetypes = { "markdown" },
            },
        })
        local zk_cmd = require("zk.commands")
        local au_group = vim.api.nvim_create_augroup("Zk", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            group = au_group,
            -- NOTE: this seems to have effect like */Documents/notebook/**/*.md?
            pattern = { "*/Documents/notebook/*.md" },
            -- TODO: do these only works once?
            callback = function()
                -- TODO: should these be buffer-local keymaps?
                vim.keymap.set("n", "<leader>fn", function()
                    zk_cmd.get("ZkNotes")({ sort = { "modified" } })
                end, { silent = true })
                -- search a tag, select, then search among the notes with that tag
                vim.keymap.set("n", "<leader>ft", function()
                    zk_cmd.get("ZkTags")()
                end, { silent = true })
                vim.keymap.set("n", "<leader>fl", function()
                    zk_cmd.get("ZkLinks")()
                end, { silent = true })
                vim.keymap.set("n", "<leader>fs", function()
                    require("fzf-lua").live_grep({
                        exec_empty_query = true,
                        cmd = "rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --type markdown -g !templates/ -e",
                    })
                end, { silent = true })

                -- toggle checkbox and keep cursor in place
                -- turn of hlsearch at end
                local function toggle_checkbox()
                    if string.match(vim.api.nvim_get_current_line(), "- %[ %]") ~= nil then
                        vim.cmd("s/- \\[ \\]/- [x]/g|norm!``")
                    elseif string.match(vim.api.nvim_get_current_line(), "- %[x%]") ~= nil then
                        vim.cmd("s/- \\[x\\]/- [ ]/g|norm!``")
                    end
                    vim.cmd("nohlsearch")
                end
                vim.keymap.set("n", "=", toggle_checkbox, { silent = true })
            end,
        })
    end,
}
