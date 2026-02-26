return {
    "lukas-reineke/indent-blankline.nvim",
    -- enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
        require("ibl").setup({
            indent = {
                char = "│",
            },
            scope = {
                char = "│",
                show_start = false,
                show_end = false,
            },
        })
    end,
}
