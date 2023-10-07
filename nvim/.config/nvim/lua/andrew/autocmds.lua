-- highlight the text you just yanked (visual cue)
local hl_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = hl_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank()
    end,
})
-- allow line wrapping for .md files
local wrap_group = vim.api.nvim_create_augroup('MarkdownWrap', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
    group = wrap_group,
    pattern = { '*.md' },
    command = 'setlocal wrap',
})
-- modify automatic formatting to not continue comments when you hit Enter
-- setting it with autocmd otherwise ftplugin overrides it
-- BufWinEnter event is late enough to override formatoptions
-- https://www.reddit.com/r/neovim/comments/sqld76/stop_automatic_newline_continuation_of_comments/
local exit_cursor_group = vim.api.nvim_create_augroup('ModAutoComment', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
    command = 'set formatoptions-=cro',
    group = exit_cursor_group,
})
