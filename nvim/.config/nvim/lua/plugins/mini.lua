return {
    {
        "echasnovski/mini.surround",
        version = false,
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("mini.surround").setup({
                -- Module mappings. Use `""` (empty string) to disable one.
                mappings = {
                    add = "sa", -- Add surrounding in Normal and Visual modes
                    delete = "sd", -- Delete surrounding
                    find = "sf", -- Find surrounding (to the right)
                    find_left = "sF", -- Find surrounding (to the left)
                    highlight = "sh", -- Highlight surrounding (a search)
                    replace = "sc", -- `sc'"` replaces single with double quotes
                    update_n_lines = "sn", -- Update `n_lines`
                    suffix_last = "l", -- Suffix to search with "prev" method
                    suffix_next = "n", -- Suffix to search with "next" method
                },
            })
        end,
    },
    {
        "echasnovski/mini.splitjoin",
        version = false,
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("mini.splitjoin").setup({
                mappings = {
                    toggle = "st",
                    split = "",
                    join = "",
                },
            })
        end,
    },
}
