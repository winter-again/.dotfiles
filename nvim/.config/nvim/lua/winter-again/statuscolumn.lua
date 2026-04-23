local M = {}
function M.render()
    local gs = require("gitsigns").statuscolumn()
    local line_num = vim.v.relnum ~= 0 and vim.v.relnum or vim.v.lnum
    return string.format("%d %s", line_num, gs)
end

-- TODO: using this causes confirmation prompt on quit
-- %= = what comes after will be right-aligned
-- %s = sign column for current line
-- %l = line number column for current line
vim.opt.statuscolumn = "%=%s%{%v:lua.require('winter-again.statuscolumn').render()%}"
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%s"
vim.opt.signcolumn = "yes:1"

return M
