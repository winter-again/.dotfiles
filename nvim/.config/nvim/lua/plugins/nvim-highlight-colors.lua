return {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("nvim-highlight-colors").setup({
            render = "background", -- or virtual
            virtual_symbol = "■",
            enable_named_colors = true,
            enable_tailwind = true,
            exclude_filetypes = {
                "lazy",
                "markdown",
            },
        })
    end,
}
