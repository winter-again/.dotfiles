return {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("todo-comments").setup({
            search = {
                commands = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden", -- had to add for stuff to show in dotfiles
                    "--glob='!{.git,.venv,node_modules}/*'",
                },
            },
        })

        local map = require("winter-again.globals").map
        map("n", "]t", function()
            require("todo-comments").jump_next()
        end, { silent = true }, "Next TODO comment")
        map("n", "[t", function()
            require("todo-comments").jump_next()
        end, { silent = true }, "Previous TODO comment")
        map("n", "<leader>ft", function()
            local ok_telescope, _ = pcall(require, "telescope")
            local ok_fzf_lua, _ = pcall(require, "fzf-lua")
            if ok_telescope then
                vim.cmd("TodoTelescope")
            elseif ok_fzf_lua then
                vim.cmd("TodoFzfLua")
            end
        end, { silent = true }, "Search TODO-style comments")
    end,
}
