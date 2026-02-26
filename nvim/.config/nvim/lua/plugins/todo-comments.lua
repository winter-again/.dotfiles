return {
    "folke/todo-comments.nvim",
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
                    "--glob=!.git",
                },
            },
        })
        vim.keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
        end, { silent = true, desc = "Next TODO comment" })
        vim.keymap.set("n", "[t", function()
            require("todo-comments").jump_next()
        end, { silent = true, desc = "Previous TODO comment" })
        vim.keymap.set("n", "<leader>ft", function()
            local ok_telescope, _ = pcall(require, "telescope")
            local ok_fzf_lua, _ = pcall(require, "fzf-lua")
            if ok_telescope then
                vim.cmd("TodoTelescope")
            elseif ok_fzf_lua then
                vim.cmd("TodoFzfLua")
            end
        end, { silent = true, desc = "Search TODO-style comments" })
    end,
}
