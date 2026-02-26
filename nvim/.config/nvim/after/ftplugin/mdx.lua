local map = require("winter-again.globals").map

vim.opt_local.wrap = true
-- wrap long lines at chars in breakat var
vim.opt_local.linebreak = true
-- wrapped lines keep any indents
vim.opt_local.breakindent = true

vim.opt_local.spell = true

-- toggle checkbox and keep cursor in place
local function toggle_checkbox()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_line = cursor[1] - 1
    local cur_line = vim.api.nvim_get_current_line()
    local checked = "%[x%]"
    local unchecked = "%[ %]"

    local new_line = ""
    if cur_line:find(checked) then
        new_line = cur_line:gsub(checked, unchecked, 1)
        vim.api.nvim_buf_set_lines(0, cursor_line, cursor_line + 1, false, { new_line })
    elseif cur_line:find(unchecked) then
        new_line = cur_line:gsub(unchecked, checked, 1)
        vim.api.nvim_buf_set_lines(0, cursor_line, cursor_line + 1, false, { new_line })
    end

    vim.api.nvim_win_set_cursor(0, cursor)
end

map("n", "=", toggle_checkbox, { silent = true, buffer = true }, "Toggle markdown checkbox")
