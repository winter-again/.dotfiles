local au_group = vim.api.nvim_create_augroup("winter.again", { clear = true })

-- highlight yanked text (visual cue)
vim.api.nvim_create_autocmd("TextYankPost", {
    group = au_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- from lazyvim
-- auto create dir when saving a file, in case some parent directory doesn't exist
-- can use :e to create a buffer by name and then :w will create it before writing
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = au_group,
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- trying to get rid of folds in diffsplit with fugitive
-- not perfect but it kind of works
vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
    group = au_group,
    command = "set nofen",
})

-- remove items from qflist
-- source: https://github.com/rmarganti/.dotfiles/blob/main/dots/.config/nvim/lua/rmarganti/core/autocommands.lua#L12
local function del_qflist()
    local mode = vim.api.nvim_get_mode()["mode"]

    local start
    local count

    if mode == "n" then
        start = vim.fn.line(".")
        count = vim.v.count > 0 and vim.v.count or 1
    else
        local v_start = vim.fn.line("v")
        local v_end = vim.fn.line(".")

        start = math.min(v_start, v_end)
        count = math.abs(v_end - v_start) + 1

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", false)
    end

    local qflist = vim.fn.getqflist()

    for _ = 1, count, 1 do
        table.remove(qflist, start)
    end

    vim.fn.setqflist(qflist, "r")
    vim.fn.cursor(start, 1)
end

vim.api.nvim_create_autocmd("FileType", {
    group = au_group,
    pattern = "qf",
    callback = function()
        vim.api.nvim_set_option_value("buflisted", false, { buf = 0 })
        vim.keymap.set("n", "dd", del_qflist, { buffer = true })
        vim.keymap.set("", "d", del_qflist, { buffer = true })
    end,
})

-- TODO: only a hunch that this is necessary
-- ensure these are set even if files loaded from session
vim.api.nvim_create_autocmd("BufRead", {
    group = au_group,
    pattern = { "markdown", "mdx" },
    callback = function()
        vim.opt_local.wrap = true
        -- wrap long lines at chars in breakat var
        vim.opt_local.linebreak = true
        -- wrapped lines keep any indents
        vim.opt_local.breakindent = true
        vim.opt_local.spell = true
    end,
})
