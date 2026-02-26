return {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    config = function()
        require("typst-preview").setup({
            port = 8000,
            dependencies_bin = {
                ["tinymist"] = "/usr/bin/tinymist",
                ["websocat"] = "/usr/bin/websocat",
            },
        })
    end,
}
