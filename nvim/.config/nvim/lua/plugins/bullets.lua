return {
    "bullets-vim/bullets.vim",
    ft = {
        "markdown",
        "typst",
    },
    init = function()
        vim.g.bullets_set_mappings = 1 -- 0 to disable
        vim.g.bullets_enabled_file_types = {
            "markdown",
            "typst",
        }
    end,
}
