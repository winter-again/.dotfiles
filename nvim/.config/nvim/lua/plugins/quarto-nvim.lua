return {
    'quarto-dev/quarto-nvim',
    -- version = '0.13.2',
    dependencies = {
        'jmbuhr/otter.nvim',
        'hrsh7th/nvim-cmp',
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
    },
    dev = false,
    ft = 'quarto',
    config = function()
        require('quarto').setup({
            closePreviewOnExit = true,
            lspFeatures = {
                enabled = true,
                languages = { 'r', 'python', 'julia' },
                chunks = 'curly',
                diagnostics = {
                    enabled = true,
                    triggers = { 'BufWritePost' },
                },
                completion = {
                    enabled = true,
                },
            },
        })
        -- add some specific keymaps
        Map('n', 'cir', 'i```{r}<cr>```<esc>O<esc>', { silent = true }, 'Insert R code chunk and enter in insert mode')
        Map(
            'n',
            'cip',
            'i```{python}<cr>```<esc>O<esc>',
            { silent = true },
            'Insert Python code chunk and enter in insert mode'
        )
        Map('n', '<leader>qp', ":lua require('quarto').quartoPreview()<cr>", { silent = true }, 'Quarto preview')
        Map(
            'n',
            '<leader>qq',
            ":lua require('quarto').quartoClosePreview()<cr>",
            { silent = true },
            'Close Quarto preview'
        )
    end,
}
