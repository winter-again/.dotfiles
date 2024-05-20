return {
    'ibhagwan/fzf-lua',
    -- 'https://gitlab.com/ibhagwan/fzf-lua', -- Gitlab alt
    -- keys = {
    --     '<leader>ff',
    --     '<leader>fl',
    --     '<leader>hl',
    --     '<leader>fk',
    --     '<leader>fc',
    -- },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local fzf_lua = require('fzf-lua')
        fzf_lua.setup()

        local function map(mode, lhs, rhs, opts, desc)
            opts = opts or {}
            opts.desc = desc
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        local opts = { silent = true }

        map('n', '<leader>ff', fzf_lua.files, opts, 'Find files')
        map('n', '<leader>fl', fzf_lua.buffers, opts, 'Find buffers')
        map('n', '<leader>hl', fzf_lua.highlights, opts, 'Find hl groups')
        map('n', '<leader>fc', fzf_lua.colorschemes, opts, 'Find colorscheme')
        map('n', '<leader>fk', fzf_lua.keymaps, opts, 'Find keymap')
        map('n', '<leader>fd', fzf_lua.diagnostics_document, opts, 'Find buffer diagnostics')
        map('n', '<leader>fD', fzf_lua.diagnostics_workspace, opts, 'Find workspace diagnostics')

        map('n', '<leader>fq', fzf_lua.quickfix, opts, 'Find quickfix')
        map('n', '<leader>fj', fzf_lua.jumps, opts, 'Find jumps')
        map('n', '<leader>fa', fzf_lua.autocmds, opts, 'Find autocommands')
        map('n', '<leader>fh', fzf_lua.helptags, opts, 'Find help tags')
        map('n', '<leader>fr', fzf_lua.registers, opts, 'Find register')

        -- map('n', '<leader>fzs', function()
        --     require('fzf-lua').live_grep_glob({
        --         exec_empty_query = true,
        --         cmd = 'rg --hidden --glob !**/.git/* --glob !**/.venv/* --glob !**/node_modules/*',
        --     })
        -- end, opts, 'Find live grep')
        -- map('n', '<leader>fz/', fzf_lua.lgrep_curbuf, opts, 'Find in current buffer')
    end,
}
