return {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup({
            relculright = true, -- align the current line number with rest of col
            segments = {
                -- for getting annotate.nvim extmarks to show
                -- {
                --     sign = { namespace = { 'annotate' }, colwidth = 1, maxwidth = 1, auto = false },
                -- },
                -- fold col
                -- { text = { builtin.foldfunc }, click = 'v:lua.ScFa' }, -- fold column replacement

                -- diagnostics
                {
                    sign = {
                        namespace = { 'diagnostic' },
                        maxwidth = 1, -- max num of signs to display
                        colwidth = 2, -- num of cells to display *per sign*; can act as padding I think
                        auto = false, -- when true, segment not draw if no signs match
                    },
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
                    sign = {
                        namespace = { 'gitsign' },
                        maxwidth = 1,
                        colwidth = 1,
                        auto = false,
                    },
                    click = 'v:lua.ScSa',
                },
            },
        })
    end,
}
