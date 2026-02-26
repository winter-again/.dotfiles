-- change cursor to blink; otherwise should be defaults
-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250"
vim.opt.mouse = 'a' -- enable mouse mode always
vim.opt.showmode = false -- turn off the "extra" mode indicator below status line
-- disable Netrw as advised for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.swapfile = false -- turn off swapfiles
vim.opt.backup = false -- turn off backups
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true -- save undo history to an undo file and restore from too
-- line numbers; setting both of these together gives hybrid line numbering
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight current line and its line number
-- colorcol
-- vim.opt.colorcolumn = '80' -- for some reason, it's slower than expected
-- tab settings
vim.opt.tabstop = 4 -- how wide tab characters are
vim.opt.softtabstop = 4 -- how Tab and Backspace should operate 
vim.opt.shiftwidth = 4 -- number of spaces to use for autoindent
vim.opt.expandtab = true -- use only space characters in your files; i.e., using Tab inserts spaces
-- indentation
vim.opt.smartindent = true -- smart autoindenting when starting new line
-- case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true -- be smart about case when searching
vim.opt.ignorecase = true -- also set this so that smartcase takes over as needed
vim.opt.wrap = false -- no line wrapping
vim.opt.hlsearch = true -- don't keep the search match highlighted after done with search; turned it back on while using nivm-hlslens plugin
-- using this, can use n and N to move through matches
vim.opt.incsearch = true -- show search result while typing the search term
vim.opt.termguicolors = true -- nice colors
vim.opt.scrolloff = 4 -- always keep at least this number of lines above/below the cursor when scrolling
vim.opt.signcolumn = 'yes:2' -- fix signcolumn at 2 and always show 
-- vim.opt.clipboard = 'unnamedplus' -- makes all yanking use clipboard

-- highlights the text you just yanked (visual cue)
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*'
})
-- allow line wrapping for .md files
local wrap_group = vim.api.nvim_create_augroup('MarkdownWrap', {clear = true})
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = {'*.md'},
    group = wrap_group,
    command = 'setlocal wrap'
})
-- modify automatic formatting to not continue comments when you hit Enter
-- setting it with autocmd otherwise ftplugin overrides it; maybe there's a better way?
-- BufWinEnter event is late enough to override formatoptions
-- https://www.reddit.com/r/neovim/comments/sqld76/stop_automatic_newline_continuation_of_comments/
local exit_cursor_group = vim.api.nvim_create_augroup('ModAutoComment', { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", { command = 'set formatoptions-=cro', group = exit_cursor_group })
vim.opt.updatetime = 1000 -- faster updatetime for triggering plugins; default is 4000 ms
-- settings for which-key plugin
vim.opt.timeout = true
vim.opt.timeoutlen = 300
-- set a global statusline
vim.opt.laststatus = 3
-- set what winbar displays at the top
-- vim.opt.winbar = "%f %m" -- normal way of doing it
-- vim.opt.winbar = "%{%v:lua.require('andrew.winbar').eval()%}" -- modified way that swaps the slashes to use Unix convention
-- better completion experience
-- menuone = use menu also when there is only one match
-- noselect = don't preselect
vim.opt.completeopt = 'menuone,noselect'
-- settings for folding, which is handled by nvim-ufo plugin
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
-- what gets saved in sessions
vim.opt.sessionoptions = 'buffers,curdir,folds,globals,winpos,winsize'
-- (pseudo)transparency for cmp menu (0 = fully opaque, 100 = fully transparent)
-- doesn't apply to documentation, which is nice
-- note: setting it means cmp menu has highlight but can see text behind
-- not setting + having transparent bg lets just the transparent background show
vim.opt.pumblend = 30
--------------------------------------------------------------------------------------------------------
-- key remaps:
-- docs: https://neovim.io/doc/user/vimindex.html
-- how to use vim.keymap.set(): https://neovim.io/doc/user/lua.html#vim.keymap.set()
-- defaults to NOT use recursive mapping
local opts = {silent = true} -- prevents printing to command line
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', opts) -- unbind space in case it interferes with leader setting
vim.keymap.set('n', '<leader>pv', ':NvimTreeToggle<CR>', opts) -- toggle file tree
-- create splits
vim.keymap.set('n', '<leader>sh', ':split<CR><C-w>w', opts) -- horizontal split current buffer
vim.keymap.set('n', '<leader>sv', ':vsplit<CR><C-w>w', opts) -- vertical split current buffer
-- moving between windows
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)
-- resize window with arrow keys
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', opts) -- make active window longer
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>') -- make active window shorter
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts) -- make active window thinner
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts) -- make active window wider
-- stuff below now handled by mini-move plugin
-- indent highlighted selection but stay in visual mode so it can continuously move the text
-- now covered by mini.move plugin
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
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', opts)
vim.keymap.set('n', '<leader>Y', '"+Y', opts)
-- delete into clipboard
-- vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
-- vim.keymap.set({'n', 'v'}, '<leader>D', '"+D')
-- paste from clipboard
-- vim.keymap.set('n', '<leader>p', '"+p')
-- vim.keymap.set('n', '<leader>P', '"+P')
-- delete to black hole register to prevent overwriting
vim.keymap.set({'n', 'v'}, '<leader>d', '"_d', opts)
-- disable "Q"
-- apparently "Q" would replay the last recorded macro?
-- https://github.com/neovim/neovim/issues/15404
vim.keymap.set('n', 'Q', '<nop>', opts)
-- replace all for the word cursor is on; just delete and start typing the replacement text
-- the search string appears at bottom
vim.keymap.set('n', '<leader>rs', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', opts)
-- increment and decrement remap
vim.keymap.set('n', '+', '<C-a>', opts)
vim.keymap.set('n', '-', '<C-x>', opts)
-- select all in doc
vim.keymap.set('n', '<C-a>', 'gg<S-v>G', opts)
-- cycle through buffers if not using bufferline
-- vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', {silent = true})
-- vim.keymap.set('n', '<S-Tab>', '<cmd>bprev<CR>', {silent = true})
-- with Netrw disabled, use this to follow hyperlinks
vim.keymap.set('n', 'gx', [[:silent execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)
-- set transparency
vim.keymap.set('n', '<leader>o', ':lua Transp()<CR>')
-- delete buffer without losing window layout
vim.keymap.set('n', '<leader>db', ':bn<CR>:bd#<CR>')
