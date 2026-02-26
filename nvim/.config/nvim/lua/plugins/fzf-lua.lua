return {
    'ibhagwan/fzf-lua',
    keys = {
        '<leader>ff',
        '<leader>fzf',
        '<leader>fk',
        '<leader>fc',
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local actions = require('fzf-lua.actions')
        require('fzf-lua').setup()
        local opts = { silent = true }
        Map('n', '<leader>ff', '<cmd>lua require("fzf-lua").files()<CR>', opts, 'fzf-lua')
        Map('n', '<leader>fzl', '<cmd>lua require("fzf-lua").buffers()<CR>', opts, 'fzf-lua')
        Map('n', '<leader>fzs', function()
            require('fzf-lua').live_grep_glob({
                exec_empty_query = true,
                cmd = 'rg --hidden --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/*',
            })
        end, opts, 'fzf-lua')
        Map('n', '<leader>fz/', '<cmd>lua require("fzf-lua").lgrep_curbuf()<CR>', opts, 'fzf-lua')
        -- colorscheme actually shows preview on hover
        Map('n', '<leader>fc', '<cmd>lua require("fzf-lua").colorschemes()<CR>', opts, 'fzf-lua')
        -- does this actually show where defined? seems more like the source file
        Map('n', '<leader>fk', '<cmd>lua require("fzf-lua").keymaps()<CR>', opts, 'fzf-lua')
        Map('n', '<leader>fzr', '<cmd>lua require("fzf-lua").registers()<CR>', opts, 'fzf-lua')
    end,
}
