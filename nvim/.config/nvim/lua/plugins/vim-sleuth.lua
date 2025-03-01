return {
    "tpope/vim-sleuth",
    config = function()
        -- disable for markdown
        vim.g.sleuth_markdown_heuristics = false
    end,
}
