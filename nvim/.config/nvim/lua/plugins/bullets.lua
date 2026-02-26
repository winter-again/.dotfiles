return {
    "bullets-vim/bullets.vim",
    ft = "markdown",
    init = function()
        vim.g.bullets_set_mappings = 1 -- 0 to disable
    end,
}
