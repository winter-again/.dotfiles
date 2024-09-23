return {
    "quarto-dev/quarto-nvim",
    -- version = '0.13.2',
    dependencies = {
        "jmbuhr/otter.nvim",
        "hrsh7th/nvim-cmp",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    dev = false,
    ft = "quarto",
    enabled = false,
    config = function()
        require("quarto").setup({
            closePreviewOnExit = true,
            lspFeatures = {
                enabled = true,
                languages = { "r", "python", "julia" },
                chunks = "curly",
                diagnostics = {
                    enabled = true,
                    triggers = { "BufWritePost" },
                },
                completion = {
                    enabled = true,
                },
            },
        })
        -- add some specific keymaps
        vim.keymap.set(
            "n",
            "cir",
            "i```{r}<cr>```<esc>O<esc>",
            { silent = true, desc = "Insert R code chunk and enter in insert mode" }
        )
        vim.keymap.set(
            "n",
            "cip",
            "i```{python}<cr>```<esc>O<esc>",
            { silent = true, desc = "Insert Python code chunk and enter in insert mode" }
        )
        vim.keymap.set(
            "n",
            "<leader>qp",
            ":lua require('quarto').quartoPreview()<cr>",
            { silent = true, desc = "Quarto preview" }
        )
        vim.keymap.set(
            "n",
            "<leader>qq",
            ":lua require('quarto').quartoClosePreview()<cr>",
            { silent = true, desc = "Close Quarto preview" }
        )
    end,
}
