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
                    "--hidden", -- had to add for stuff to show in lua at least
                    -- '--no-ignore-vcs',
                },
            },
        })
        vim.keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
        end, { silent = true, desc = "Next TODO comment" })
        vim.keymap.set("n", "[t", function()
            require("todo-comments").jump_next()
        end, { silent = true, desc = "Previous TODO comment" })
    end,
}
