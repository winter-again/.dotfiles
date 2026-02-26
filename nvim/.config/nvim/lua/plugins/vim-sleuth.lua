return {
    "tpope/vim-sleuth",
    cond = function()
        if vim.bo.filetype == "markdown" then
            return false
        end
        return true
    end,
}
