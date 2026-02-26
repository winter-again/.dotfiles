return {
    "jmbuhr/otter.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    ft = { "markdown" },
}
