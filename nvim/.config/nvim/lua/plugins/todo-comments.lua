return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('todo-comments').setup({
            search = {
                commands = 'rg',
                args = {
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--hidden', -- had to add for stuff to show in lua at least
                    -- '--no-ignore-vcs',
                },
            },
        })
        Map('n', '<leader><leader>ft', '<cmd>TodoTelescope<CR>', { silent = true }, 'Search TODO comments')
    end,
}
