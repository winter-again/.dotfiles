return {
    'ibhagwan/fzf-lua',
    -- 'https://gitlab.com/ibhagwan/fzf-lua', -- Gitlab alt
    keys = {
        '<leader>ff',
        '<leader>fzf',
        '<leader>fk',
        '<leader>fc',
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- local actions = require('fzf-lua.actions')
        require('fzf-lua').setup()

        local map = function(mode, lhs, rhs, opts, desc)
            opts = opts or {}
            opts.desc = desc
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        local opts = { silent = true }
        map('n', '<leader>ff', '<cmd>lua require("fzf-lua").files()<CR>', opts, 'Find files')
        map('n', '<leader>fzl', '<cmd>lua require("fzf-lua").buffers()<CR>', opts, 'Find buffers')
        map('n', '<leader>fzs', function()
            require('fzf-lua').live_grep_glob({
                exec_empty_query = true,
                cmd = 'rg --hidden --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/*',
            })
        end, opts, 'Find live grep')
        map('n', '<leader>fz/', '<cmd>lua require("fzf-lua").lgrep_curbuf()<CR>', opts, 'Find in current buffer')
        -- colorscheme actually shows preview on hover
        map('n', '<leader>fc', '<cmd>lua require("fzf-lua").colorschemes()<CR>', opts, 'Find colorscheme')
        -- does this actually show where defined? seems more like the source file
        map('n', '<leader>fk', '<cmd>lua require("fzf-lua").keymaps()<CR>', opts, 'Find keymap')
        map('n', '<leader>fzr', '<cmd>lua require("fzf-lua").registers()<CR>', opts, 'Find register')
    end,
}
