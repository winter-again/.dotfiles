local opts = { silent = true }
Map({ 'n', 'v' }, '<Space>', '<Nop>', opts, 'Unbind space')
-- split windows (reversed for my brain)
Map('n', '<leader>sh', ':split<CR><C-w>w', opts, 'Horizontal split')
Map('n', '<leader>sv', ':vsplit<CR><C-w>w', opts, 'Vertical split')
Map('n', '<C-h>', '<C-w>h', opts, 'Move left')
Map('n', '<C-j>', '<C-w>j', opts, 'Move down')
Map('n', '<C-k>', '<C-w>k', opts, 'Move up')
Map('n', '<C-l>', '<C-w>l', opts, 'Move right')
Map('n', '<Up>', ':resize +2<CR>', opts, 'Window longer')
Map('n', '<Down>', ':resize -2<CR>', opts, 'Window shorter')
Map('n', '<Left>', ':vertical resize -2<CR>', opts, 'Window thinner')
Map('n', '<Right>', ':vertical resize +2<CR>', opts, 'Window wider')
-- below now handled by mini-move plugin
-- move highlighted selection up/down and should autoindent as needed
-- for example, into/out of if statements or loops
-- indent highlighted selection but stay in visual mode so it can continuously move the text
-- vim.keymap.set("v", "<", "<gv", opts)
-- vim.keymap.set("v", ">", ">gv", opts)
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
-- J in normal mode appends line below to your current line + a space
-- this remap keeps cursor in place instead of sending it to end of line
Map('n', 'J', 'mzJ`z', opts, 'Append line below to current line w/ space')
Map('n', '<C-d>', '<C-d>zz', opts, 'No dizziness from page jump')
Map('n', '<C-u>', '<C-u>zz', opts, 'No dizziness from page jump')
Map('n', 'n', 'nzzzv', opts, 'Center search hit')
Map('n', 'N', 'Nzzzv', opts, 'Center search hit')
-- keep cursor at the bottom of selection after yanking it
-- vim.keymap.set('v', 'y', 'ygv<esc>', opts)
Map('x', '<leader>p', '"_dP', opts, 'Paste w/o losing')
Map({ 'n', 'v' }, '<leader>y', '"+y', opts, 'Yank w/o losing')
Map('n', '<leader>Y', '"+Y', opts, 'Yank line w/o losing')
-- delete into clipboard
-- vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
-- vim.keymap.set({'n', 'v'}, '<leader>D', '"+D')
-- paste from clipboard
-- vim.keymap.set('n', '<leader>p', '"+p')
-- vim.keymap.set('n', '<leader>P', '"+P')
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
-- with Netrw disabled, use this to follow hyperlinks
-- vim.keymap.set('n', 'gx', [[:silent execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)
-- special
Map('n', '<leader>pv', '<cmd>NvimTreeToggle<CR>', opts, 'Toggle nvim-tree')
Map('n', '<leader><leader>c', '<cmd>close<CR>', opts, 'Close window w/o accidentally quitting')
Map('n', '<leader><leader>x', '<cmd>lua Save_exec()<CR>', opts, 'Save and exec Lua file')
Map('n', '<leader><leader>t', '<cmd>Transp<CR>', opts, 'Turn on transparency')
Map('n', '<leader><leader>d', '<cmd>ToggleLightDark<CR>', opts, 'Toggle light/dark mode')
Map('n', '<leader><leader>r', '<cmd>lua R("winter-again.nvim")<CR>', opts, 'Reload this plugin')
