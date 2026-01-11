local filetypes = {
    "markdown",
    "mdx",
    -- "typst",
}

return {
    "bullets-vim/bullets.vim",
    ft = filetypes,
    init = function()
        vim.g.bullets_set_mappings = 1 -- 0 to disable
        vim.g.bullets_delete_last_bullet_if_empty = 2 -- last empty bullet behavior
        vim.g.bullets_pad_right = 0 -- don't add extra space between bullet and text
        vim.g.bullets_outline_levels = { "num", "std-" } -- only use numbers and  "-" as bullets?
        vim.g.bullets_enabled_file_types = filetypes
    end,
}
