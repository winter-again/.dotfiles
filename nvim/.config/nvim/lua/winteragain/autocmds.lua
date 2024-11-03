local au_group = vim.api.nvim_create_augroup("WinterAgain", { clear = true })

-- highlight the text you just yanked (visual cue)
vim.api.nvim_create_autocmd("TextYankPost", {
    group = au_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- from lazyvim
-- auto create dir when saving a file, in case some intermediate directory does not exist
-- can use :e to create a buffer by name and then :w actually creates it before write
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

-- get rid of status column inside of nvim tree buffer
-- the builtin setting didn't seem to work
vim.api.nvim_create_autocmd("BufEnter", {
    group = au_group,
    callback = function()
        if vim.bo.filetype == "NvimTree" then
            vim.wo.statuscolumn = ""
        end
    end,
})

-- trying to get rid of folds in diffsplit with fugitive
-- not perfect but it kind of works
vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
    group = au_group,
    command = "set nofen",
})

-- disable treesitter context in .md files if having issues
vim.api.nvim_create_autocmd("FileType", {
    group = au_group,
    pattern = { "markdown" },
    callback = function()
        require("treesitter-context").disable()
    end,
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
    group = "WinterAgain",
    pattern = "qf",
    callback = function()
        vim.api.nvim_set_option_value("buflisted", false, { buf = 0 })
        vim.keymap.set("n", "dd", del_qflist, { buffer = true })
        vim.keymap.set("", "d", del_qflist, { buffer = true })
    end,
})

-- modify automatic formatting to not continue comments when you hit Enter
-- setting it with autocmd otherwise ftplugin overrides it
-- BufWinEnter event is late enough to override formatoptions
-- https://www.reddit.com/r/neovim/comments/sqld76/stop_automatic_newline_continuation_of_comments/
-- local exit_cursor_group = vim.api.nvim_create_augroup('ModAutoComment', { clear = true })
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--     command = 'set formatoptions-=cro',
--     group = exit_cursor_group,
-- })
