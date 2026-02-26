local function map(mode, lhs, rhs, opts, desc)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end
local opts = { silent = true }

-- map('n', '<leader>pv', '<cmd>Lex<CR>', opts, 'Open Netrw to the left')
map('n', '<leader>w', function()
    vim.cmd('silent! write')
end, opts, 'Write buf')
map({ 'n', 'v' }, '<Space>', '<Nop>', opts, 'Unbind space')
map('n', '<Esc>', '<cmd>nohlsearch<CR>', opts, 'Turn off search highlights')
-- split windows (reversed for my brain)
map('n', '<leader>sh', ':split<CR><C-w>w', opts, 'Horizontal split')
map('n', '<leader>sv', ':vsplit<CR><C-w>w', opts, 'Vertical split')
map('n', '<leader><leader>c', '<cmd>close<CR>', opts, 'Close window w/o accidentally quitting')
map('n', '<C-h>', '<C-w>h', opts, 'Move left')
map('n', '<C-j>', '<C-w>j', opts, 'Move down')
map('n', '<C-k>', '<C-w>k', opts, 'Move up')
map('n', '<C-l>', '<C-w>l', opts, 'Move right')
map('n', '<Up>', ':resize +2<CR>', opts, 'Window longer')
map('n', '<Down>', ':resize -2<CR>', opts, 'Window shorter')
map('n', '<Left>', ':vertical resize -2<CR>', opts, 'Window thinner')
map('n', '<Right>', ':vertical resize +2<CR>', opts, 'Window wider')
-- move selection around and autoindent as needed
map('v', 'H', '<gv', opts, 'Move selection left')
map('v', 'L', '>gv', opts, 'Move selection right')
map('v', 'J', ":m '>+1<CR>gv=gv", opts, 'Move selection down')
map('v', 'K', ":m '<-2<CR>gv=gv", opts, 'Move selection up')
-- J in normal mode appends line below to your current line + a space
-- this remap keeps cursor in place instead of sending it to end of line
map('n', 'J', 'mzJ`z', opts, 'Append line below to current line w/ space')
map('n', '<C-d>', '<C-d>zz', opts, 'Move down w/o dizziness')
map('n', '<C-u>', '<C-u>zz', opts, 'Move up w/o dizziness')
map('n', 'n', 'nzzzv', opts, 'Center next search result')
map('n', 'N', 'Nzzzv', opts, 'Center previous search result')
map('v', 'y', 'ygv<esc>', opts, 'Keep cursor at end of sel after yank')
map('n', '<leader>y', '"+y', opts, 'Yank w/o losing')
map('v', '<leader>y', '"+ygv<esc>', opts, 'Keep cursor at end of sel after special yank')
map('n', '<leader>Y', '"+Y', opts, 'Yank line w/o losing')
map('x', '<leader>p', '"_dP', opts, 'Paste w/o losing')
-- paste from clipboard
-- vim.keymap.map('n', '<leader>p', '"+p')
-- vim.keymap.map('n', '<leader>P', '"+P')
-- delete into clipboard
-- vim.keymap.map({'n', 'v'}, '<leader>d', '"+d')
-- vim.keymap.map({'n', 'v'}, '<leader>D', '"+D')
map({ 'n', 'v' }, '<leader>d', '"_d', opts, 'Delete to black hole register')
map('n', 'Q', '<nop>', opts, 'Disable Q')
-- replace all for the word cursor is on; just delete and start typing the replacement text
-- the search string appears at bottom
map('n', '<leader>rs', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', opts, 'Replace under cursor')
map('n', '+', '<C-a>', opts, 'Increment')
map('n', '-', '<C-x>', opts, 'Decrement')
map('n', '<C-a>', 'gg<S-v>G', opts, 'Select all')
-- cycle through buffers if not using bufferline
map('n', '<Tab>', '<cmd>bnext<CR>', opts, 'Next buffer')
map('n', '<S-Tab>', '<cmd>bprev<CR>', opts, 'Previous buffer')
map('n', '<leader>db', '<cmd>bn<CR><cmd>bd#<CR>', opts, 'Delete buffer w/o closing window')
-- nav quickfix list
map('n', '<leader>cn', '<cmd>cnext<CR>zz', opts, 'Next quickfixlist')
map('n', '<leader>cp', '<cmd>cprev<CR>zz', opts, 'Prev quickfixlist')
-- with Netrw disabled, use this to follow hyperlinks
-- v0.10 now has as default
-- map('n', 'gx', '<cmd>silent !xdg-open <cfile><CR>', opts, 'Open link')
-- <cfile> is replaced with path name under cursor
-- map('n', 'gx', function()
--     vim.ui.open(vim.fn.expand('<cfile>'))
-- end, opts, 'Open link')
map('n', '<leader>x', Save_exec_line, opts, 'Save and exec current line of Lua file')
map('n', '<leader><leader>x', Save_exec, opts, 'Save and exec Lua file')
map('n', '<leader><leader>t', '<cmd>Transp<CR>', opts, 'Turn on transparency')
map('n', '<leader><leader>m', '<cmd>ToggleLightDark<CR>', opts, 'Toggle light/dark mode')
map('n', '<leader><leader>r', '<cmd>lua R("winter-again.nvim")<CR>', opts, 'Reload this plugin')
map('n', '<leader>pr', '<cmd>lua require("persistence").load()<CR>', opts, 'Load session for dir') -- session for current dir and current branch
-- map('t', '<esc><esc>', '<c-\\><c-n>', opts, 'Escape terminal mode') -- seems to conflict with fzf-lua
