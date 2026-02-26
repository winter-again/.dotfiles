local filetypes = {
    "markdown",
    "mdx",
    "typst",
}

return {
    "bullets-vim/bullets.vim",
    ft = filetypes,
    init = function()
        vim.g.bullets_set_mappings = 1 -- 0 to disable
        vim.g.bullets_enabled_file_types = filetypes
    end,
}
