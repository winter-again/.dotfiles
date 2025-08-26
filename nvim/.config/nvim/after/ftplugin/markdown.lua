local map = require("winteragain.globals").map

vim.opt_local.wrap = true
-- wrap long lines at chars in breakat var
vim.opt_local.linebreak = true
-- wrapped lines keep any indents
vim.opt_local.breakindent = true

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- 1 makes concealed links look too long because it has to be a 1:1 conceal, meaning the "["
-- is concealed with just a blank
-- vim.opt_local.conceallevel = 2
-- vim.opt_local.concealcursor = "nc" -- modes in which text in cursor line can remain concealed

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

-- activate otter.nvim for JS in specific case
local cwd = vim.uv.cwd()
if cwd ~= vim.fs.normalize("~/Documents/notebook") and vim.uv.fs_stat("package.json") then
    local otter = require("otter")
    otter.activate({ "javascript" })
end
