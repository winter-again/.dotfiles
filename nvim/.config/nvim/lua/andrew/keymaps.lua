-- defaults to NOT use recursive mapping
local opts = { silent = true } -- prevents printing to command line
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', opts) -- unbind space in case it interferes with leader setting
-- split windows (reversed for my brain)
vim.keymap.set('n', '<leader>sh', ':split<CR><C-w>w', opts)
vim.keymap.set('n', '<leader>sv', ':vsplit<CR><C-w>w', opts)
-- moving between windows
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)
-- resize window
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', opts) -- make active window longer
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>') -- make active window shorter
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts) -- make active window thinner
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts) -- make active window wider
-- below now handled by mini-move plugin
-- indent highlighted selection but stay in visual mode so it can continuously move the text
-- vim.keymap.set("v", "<", "<gv", opts)
-- vim.keymap.set("v", ">", ">gv", opts)
-- move highlighted selection up/down and should autoindent as needed
-- for example, into/out of if statements or loops
-- use J and K for moving
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
-- J in normal mode appends line below to your current line + a space
-- this remap keeps cursor in place instead of sending it to end of line
vim.keymap.set('n', 'J', 'mzJ`z', opts)
-- don't get dizzy from half page jumping
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
-- keep search terms in middle of screen as you scroll through the matches
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)
-- keep cursor at the bottom of selection after yanking it
vim.keymap.set('v', 'y', 'ygv<esc>', opts)
-- paste without overwriting what's yanked
vim.keymap.set('x', '<leader>p', '"_dP', opts)
-- yank into clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', opts)
vim.keymap.set('n', '<leader>Y', '"+Y', opts)
-- delete into clipboard
-- vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
-- vim.keymap.set({'n', 'v'}, '<leader>D', '"+D')
-- paste from clipboard
-- vim.keymap.set('n', '<leader>p', '"+p')
-- vim.keymap.set('n', '<leader>P', '"+P')
-- delete to black hole register to prevent overwriting
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', opts)
-- disable "Q"
-- apparently "Q" would replay the last recorded macro?
-- https://github.com/neovim/neovim/issues/15404
vim.keymap.set('n', 'Q', '<nop>', opts)
-- replace all for the word cursor is on; just delete and start typing the replacement text
-- the search string appears at bottom
vim.keymap.set('n', '<leader>rs', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', opts)
-- increment and decrement remap
vim.keymap.set('n', '-', '<C-x>', opts)
vim.keymap.set('n', '+', '<C-a>', opts)
-- select all in doc
-- vim.keymap.set('n', '<C-a>', 'gg<S-v>G', opts)
-- cycle through buffers if not using bufferline
vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprev<CR>', { silent = true })
-- with Netrw disabled, use this to follow hyperlinks
vim.keymap.set('n', 'gx', [[:silent execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)
vim.keymap.set('n', '<leader>db', '<cmd>bn<CR><cmd>bd#<CR>') -- delete buffer without losing window layout
vim.keymap.set('n', '<leader>pv', '<cmd>NvimTreeToggle<CR>', { silent = true }) -- set here since plugin only loaded on command

vim.keymap.set('n', '<leader><leader>c', '<cmd>close<CR>', opts) -- close window
vim.keymap.set('n', '<leader><leader>x', '<cmd>lua Save_exec()<CR>', opts) -- save and exec a Lua file
vim.keymap.set('n', '<leader><leader>t', '<cmd>lua Transp()<CR>', opts) -- set transparency
vim.keymap.set('n', '<leader><leader>d', '<cmd>lua Toggle_light_dark()<CR>', opts)
vim.keymap.set('n', '<leader><leader>r', '<cmd>lua R("winter-again.nvim")<CR>', opts)
