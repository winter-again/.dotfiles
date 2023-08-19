return {
    'luukvbaal/statuscol.nvim',
    event = {'BufReadPre', 'BufNewFile'},
    config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup({
            relculright = true, -- align the current line number with rest of col
            segments = {
              {text = {builtin.foldfunc}, click = 'v:lua.ScFa'}, -- fold column replacement from statuscol plugin
              {text = {'%s'}, click = 'v:lua.ScSa'}, -- sign column
              {text = {builtin.lnumfunc, ' '}, click = 'v:lua.ScLa'} -- line number
            }
        })
    end
}
