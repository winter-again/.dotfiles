return {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    -- enabled = false,
    config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup({
            relculright = true, -- align the current line number with rest of col
            segments = {
                -- for getting annotate.nvim extmarks to show
                {
                    sign = { namespace = { 'annotate' }, colwidth = 1, maxwidth = 1, auto = false },
                },
                -- fold col
                -- { text = { builtin.foldfunc }, click = 'v:lua.ScFa' }, -- fold column replacement
                -- diagnostics
                {
                    sign = { name = { '.*' }, colwidth = 2, maxwidth = 2, auto = false },
                    click = 'v:lua.ScSa',
                },
                -- default line nums
                {
                    text = { builtin.lnumfunc, ' ' },
                    condition = { true, builtin.not_empty },
                    click = 'v:lua.ScLa',
                },
                -- GitSigns
                {
                    sign = { namespace = { 'gitsign' }, maxwidth = 1, colwidth = 1, auto = false },
                    click = 'v:lua.ScSa',
                },
            },
        })
    end,
}
