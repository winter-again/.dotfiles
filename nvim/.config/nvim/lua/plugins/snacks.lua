return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        image = {
            doc = {
                enabled = true,
                inline = false,
                float = false,
                max_width = 40,
                max_height = 20,
            },
        },
        styles = {
            -- TODO: image not always centered
            snacks_image = {
                relative = "cursor",
                backdrop = false,
                border = "none",
                row = 0,
                col = 0,
            },
        },
    },
    keys = {
        {
            "<leader>im",
            function()
                Snacks.image.hover()
            end,
            desc = "Preview image",
        },
    },
}
