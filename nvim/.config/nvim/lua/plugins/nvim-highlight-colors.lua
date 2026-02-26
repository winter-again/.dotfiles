return {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("nvim-highlight-colors").setup({
            render = "virtual",
            virtual_symbol = "■", -- must set otherwise get both virtual and background
            -- virtual_symbol = "󱓻",
            enable_named_colors = true,
            enable_tailwind = true,
            exclude_filetypes = {
                "markdown",
                "lazy",
            },
        })
    end,
}
