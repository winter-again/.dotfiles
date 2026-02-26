return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = false },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        indent = {
            enabled = true,
            priority = 1,
            char = "│",
            only_scope = false,
            only_current = false,
            hl = "SnacksIndent",
            animate = {
                enabled = false,
            },
            scope = {
                enabled = true,
                priority = 200,
                char = "│",
                hl = "SnacksIndentScope",
            },
            chunk = {
                enabled = false,
            },
        },
        input = { enabled = false },
        picker = { enabled = false },
        notifier = { enabled = false },
        quickfile = { enabled = false },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = false },
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
