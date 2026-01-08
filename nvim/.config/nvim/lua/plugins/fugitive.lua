return {
    "tpope/vim-fugitive",
    keys = { "<leader>gs" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { silent = true, desc = "Open fugitive buffer" })
    end,
}
