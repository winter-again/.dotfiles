return {
    "mbbill/undotree",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { silent = true, desc = "Toggle undotree" })
    end,
}
