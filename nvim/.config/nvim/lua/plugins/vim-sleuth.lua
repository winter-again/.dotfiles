return {
    "tpope/vim-sleuth",
    enabled = false,
    init = function()
        -- disable for markdown
        vim.g.sleuth_markdown_heuristics = false
    end,
}
