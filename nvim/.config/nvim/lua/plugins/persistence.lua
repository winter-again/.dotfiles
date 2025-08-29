return {
    "folke/persistence.nvim",
    event = "BufReadPre", -- only start session saving when an actual file is opened
    config = function()
        require("persistence").setup({
            options = { "buffers", "curdir", "winpos", "winsize" },
        })
    end,
}
