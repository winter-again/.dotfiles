local opts = { silent = true }
-- Map('n', '<leader>pv', '<cmd>Lex<CR>', opts, 'Open Netrw to the left')
Map('n', '<leader>w', function()
    vim.cmd('silent! write')
end, opts, 'Write buf')
Map({ 'n', 'v' }, '<Space>', '<Nop>', opts, 'Unbind space')
Map('n', '<Esc>', '<cmd>nohlsearch<CR>', opts, 'Turn off search highlights')
-- split windows (reversed for my brain)
Map('n', '<leader>sh', ':split<CR><C-w>w', opts, 'Horizontal split')
Map('n', '<leader>sv', ':vsplit<CR><C-w>w', opts, 'Vertical split')
Map('n', '<leader><leader>c', '<cmd>close<CR>', opts, 'Close window w/o accidentally quitting')
Map('n', '<C-h>', '<C-w>h', opts, 'Move left')
Map('n', '<C-j>', '<C-w>j', opts, 'Move down')
Map('n', '<C-k>', '<C-w>k', opts, 'Move up')
Map('n', '<C-l>', '<C-w>l', opts, 'Move right')
Map('n', '<Up>', ':resize +2<CR>', opts, 'Window longer')
Map('n', '<Down>', ':resize -2<CR>', opts, 'Window shorter')
Map('n', '<Left>', ':vertical resize -2<CR>', opts, 'Window thinner')
Map('n', '<Right>', ':vertical resize +2<CR>', opts, 'Window wider')
-- move selection around and autoindent as needed
Map('v', 'H', '<gv', opts, 'Move selection left')
Map('v', 'L', '>gv', opts, 'Move selection right')
Map('v', 'J', ":m '>+1<CR>gv=gv", opts, 'Move selection down')
Map('v', 'K', ":m '<-2<CR>gv=gv", opts, 'Move selection up')
-- J in normal mode appends line below to your current line + a space
-- this remap keeps cursor in place instead of sending it to end of line
Map('n', 'J', 'mzJ`z', opts, 'Append line below to current line w/ space')
Map('n', '<C-d>', '<C-d>zz', opts, 'Move down w/o dizziness')
Map('n', '<C-u>', '<C-u>zz', opts, 'Move up w/o dizziness')
Map('n', 'n', 'nzzzv', opts, 'Center next search result')
Map('n', 'N', 'Nzzzv', opts, 'Center previous search result')
Map('v', 'y', 'ygv<esc>', opts, 'Keep cursor at end of sel after yank')
Map('n', '<leader>y', '"+y', opts, 'Yank w/o losing')
Map('v', '<leader>y', '"+ygv<esc>', opts, 'Keep cursor at end of sel after special yank')
Map('n', '<leader>Y', '"+Y', opts, 'Yank line w/o losing')
Map('x', '<leader>p', '"_dP', opts, 'Paste w/o losing')
-- paste from clipboard
-- vim.keymap.set('n', '<leader>p', '"+p')
-- vim.keymap.set('n', '<leader>P', '"+P')
-- delete into clipboard
-- vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
-- vim.keymap.set({'n', 'v'}, '<leader>D', '"+D')
Map({ 'n', 'v' }, '<leader>d', '"_d', opts, 'Delete to black hole register')
Map('n', 'Q', '<nop>', opts, 'Disable Q')
-- replace all for the word cursor is on; just delete and start typing the replacement text
-- the search string appears at bottom
Map('n', '<leader>rs', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', opts, 'Replace under cursor')
Map('n', '+', '<C-a>', opts, 'Increment')
Map('n', '-', '<C-x>', opts, 'Decrement')
Map('n', '<C-a>', 'gg<S-v>G', opts, 'Select all')
-- cycle through buffers if not using bufferline
Map('n', '<Tab>', '<cmd>bnext<CR>', opts, 'Next buffer')
Map('n', '<S-Tab>', '<cmd>bprev<CR>', opts, 'Previous buffer')
Map('n', '<leader>db', '<cmd>bn<CR><cmd>bd#<CR>', opts, 'Delete buffer w/o closing window')
-- nav quickfix list
Map('n', '<leader>qn', '<cmd>cnext<CR>zz', opts, 'Next quickfixlist')
Map('n', '<leader>qp', '<cmd>cprev<CR>zz', opts, 'Prev quickfixlist')
-- with Netrw disabled, use this to follow hyperlinks
-- Map('n', 'gx', '<cmd>silent !xdg-open <cfile><CR>', opts, 'Open link')
-- <cfile> is replaced with path name under cursor
Map('n', 'gx', function()
    vim.ui.open(vim.fn.expand('<cfile>'))
end, opts, 'Open link')
Map('n', '<leader>x', Save_exec_line, opts, 'Save and exec current line of Lua file')
Map('n', '<leader><leader>x', Save_exec, opts, 'Save and exec Lua file')
Map('n', '<leader><leader>t', '<cmd>Transp<CR>', opts, 'Turn on transparency')
Map('n', '<leader><leader>m', '<cmd>ToggleLightDark<CR>', opts, 'Toggle light/dark mode')
Map('n', '<leader><leader>r', '<cmd>lua R("winter-again.nvim")<CR>', opts, 'Reload this plugin')
Map('n', '<leader>pr', '<cmd>lua require("persistence").load()<CR>', opts, 'Load session for dir') -- session for current dir and current branch
