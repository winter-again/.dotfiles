local au_group = vim.api.nvim_create_augroup('WinterAgain', { clear = true })

-- highlight the text you just yanked (visual cue)
vim.api.nvim_create_autocmd('TextYankPost', {
    group = au_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- from lazyvim
-- auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = au_group,
    callback = function(event)
        if event.match:match('^%w%w+://') then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- get rid of status column inside of nvim tree buffer
-- the builtin setting didn't seem to work
vim.api.nvim_create_autocmd('BufEnter', {
    group = au_group,
    callback = function()
        if vim.bo.filetype == 'NvimTree' then
            vim.wo.statuscolumn = ''
        end
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
