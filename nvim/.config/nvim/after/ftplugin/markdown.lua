vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

local cwd = vim.uv.cwd()
if cwd ~= vim.fs.normalize("~/Documents/notebook") then
    local otter = require("otter")
    otter.activate({ "javascript" })
end

-- 1 makes concealed links look too long because it has to be a 1:1 conceal, meaning the "["
-- is concealed with just a blank
vim.opt_local.conceallevel = 2
-- vim.opt_local.concealcursor = "nc" -- modes in which text in cursor line can also be concealed

-- toggle checkbox and keep cursor in place
-- turn of hlsearch at end
local function toggle_checkbox()
    if string.match(vim.api.nvim_get_current_line(), "- %[ %]") ~= nil then
        vim.cmd("s/- \\[ \\]/- [x]/g|norm!``")
    elseif string.match(vim.api.nvim_get_current_line(), "- %[x%]") ~= nil then
        vim.cmd("s/- \\[x\\]/- [ ]/g|norm!``")
    end
    vim.cmd("nohlsearch")
end
vim.keymap.set("n", "=", toggle_checkbox, { silent = true, buffer = true })
