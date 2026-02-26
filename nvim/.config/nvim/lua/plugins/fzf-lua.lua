return {
    'ibhagwan/fzf-lua',
    keys = '<leader>fzf',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('fzf-lua').setup({
            -- 'telescope',
        })
        local opts = { silent = true }
        Map('n', '<leader>fzf', '<cmd>lua require("fzf-lua").files()<CR>', opts, 'fzf-lua')
        Map('n', '<leader>fzl', '<cmd>lua require("fzf-lua").buffers()<CR>', opts, 'fzf-lua')
        Map('n', '<leader>fzs', function()
            require('fzf-lua').live_grep_glob({
                exec_empty_query = true,
                cmd = 'rg --hidden --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/*',
            })
        end, opts, 'fzf-lua')
        Map('n', '<leader>fz/', '<cmd>lua require("fzf-lua").lgrep_curbuf()<CR>', opts, 'fzf-lua')
        -- colorscheme actually shows preview on hover
        Map('n', '<leader>fzc', '<cmd>lua require("fzf-lua").colorschemes()<CR>', opts, 'fzf-lua')
        -- this actually shows where the keymap is set in the previewer
        Map('n', '<leader>fzk', '<cmd>lua require("fzf-lua").keymaps()<CR>', opts, 'fzf-lua')
        Map('n', '<leader>fzr', '<cmd>lua require("fzf-lua").registers()<CR>', opts, 'fzf-lua')
    end,
}
