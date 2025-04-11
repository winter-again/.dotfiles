local globals = require("winteragain.globals")
local opts = { silent = true }

-- map('n', '<leader>pv', '<cmd>Lex<CR>', opts, 'Open Netrw to the left')
-- map("n", "<leader>w", function()
--     vim.cmd("silent! write")
-- end, opts, "Write buf")
globals.map({ "n", "v" }, "<Space>", "<Nop>", opts, "Unbind space")
globals.map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts, "Turn off search highlights")
-- split windows (reversed for my brain)
globals.map("n", "<leader>sh", ":split<CR><C-w>w", opts, "Horizontal split")
globals.map("n", "<leader>sv", ":vsplit<CR><C-w>w", opts, "Vertical split")
globals.map("n", "<leader><leader>c", "<cmd>close<CR>", opts, "Close window")
globals.map("n", "<C-h>", "<C-w>h", opts, "Move left")
globals.map("n", "<C-j>", "<C-w>j", opts, "Move down")
globals.map("n", "<C-k>", "<C-w>k", opts, "Move up")
globals.map("n", "<C-l>", "<C-w>l", opts, "Move right")
globals.map("n", "<Up>", ":resize +2<CR>", opts, "Window longer")
globals.map("n", "<Down>", ":resize -2<CR>", opts, "Window shorter")
globals.map("n", "<Left>", ":vertical resize -2<CR>", opts, "Window thinner")
globals.map("n", "<Right>", ":vertical resize +2<CR>", opts, "Window wider")
-- move selection around and autoindent as needed
globals.map("v", "H", "<gv", opts, "Move selection left")
globals.map("v", "L", ">gv", opts, "Move selection right")
globals.map("v", "J", ":m '>+1<CR>gv=gv", opts, "Move selection down")
globals.map("v", "K", ":m '<-2<CR>gv=gv", opts, "Move selection up")
-- J in normal mode appends line below to your current line + a space
-- this remap keeps cursor in place instead of sending it to end of line
globals.map("n", "J", "mzJ`z", opts, "Append line below to current line w/ space")
globals.map("n", "<C-d>", "<C-d>zz", opts, "Move down w/o dizziness")
globals.map("n", "<C-u>", "<C-u>zz", opts, "Move up w/o dizziness")
globals.map("n", "n", "nzzzv", opts, "Center next search result")
globals.map("n", "N", "Nzzzv", opts, "Center previous search result")
globals.map("v", "y", "ygv<esc>", opts, "Keep cursor at end of sel after yank")
globals.map("n", "<leader>y", '"+y', opts, "Yank w/o losing")
globals.map("v", "<leader>y", '"+ygv<esc>', opts, "Keep cursor at end of sel after special yank")
globals.map("n", "<leader>Y", '"+Y', opts, "Yank line w/o losing")
globals.map("x", "<leader>p", '"_dP', opts, "Paste w/o losing")
-- paste from clipboard
-- vim.keymap.map('n', '<leader>p', '"+p')
-- vim.keymap.map('n', '<leader>P', '"+P')
-- delete into clipboard
-- vim.keymap.map({'n', 'v'}, '<leader>d', '"+d')
-- vim.keymap.map({'n', 'v'}, '<leader>D', '"+D')
globals.map({ "n", "v" }, "<leader>d", '"_d', opts, "Delete to black hole register")
globals.map("n", "Q", "<nop>", opts, "Disable Q")
-- replace all for the word cursor is on; just delete and start typing the replacement text
-- the search string appears at bottom
globals.map("n", "<leader>rs", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", opts, "Replace under cursor")
globals.map("n", "+", "<C-a>", opts, "Increment")
globals.map("n", "-", "<C-x>", opts, "Decrement")
globals.map("n", "<C-a>", "gg<S-v>G", opts, "Select all")
-- cycle through buffers if not using bufferline
globals.map("n", "<Tab>", "<cmd>bnext<CR>", opts, "Next buffer")
globals.map("n", "<S-Tab>", "<cmd>bprev<CR>", opts, "Previous buffer")
globals.map("n", "<leader>bd", "<cmd>bn<CR><cmd>bd#<CR>", opts, "Delete buffer w/o closing window")
-- nav quickfix list
globals.map("n", "<leader>cn", "<cmd>cnext<CR>zz", opts, "Next quickfixlist")
globals.map("n", "<leader>cp", "<cmd>cprev<CR>zz", opts, "Prev quickfixlist")
-- with Netrw disabled, use this to follow hyperlinks
-- v0.10 now has as default
-- map('n', 'gx', '<cmd>silent !xdg-open <cfile><CR>', opts, 'Open link')
-- <cfile> is replaced with path name under cursor
-- map('n', 'gx', function()
--     vim.ui.open(vim.fn.expand('<cfile>'))
-- end, opts, 'Open link')
globals.map("n", "<leader>x", function()
    globals.Save_exec_line()
end, opts, "Save and exec current line of Lua file")
globals.map("n", "<leader><leader>x", function()
    globals.Save_exec()
end, opts, "Save and exec Lua file")
globals.map("n", "<leader><leader>t", "<cmd>Transp<CR>", opts, "Turn on transparency")
-- globals.map("n", "<leader><leader>m", "<cmd>ToggleLightDark<CR>", opts, "Toggle light/dark mode")
globals.map("n", "<leader><leader>r", function()
    R("winter-again.nvim")
end, opts, "Reload this plugin")
globals.map("n", "<leader>pr", function()
    require("persistence").load()
end, opts, "Load session for dir") -- session for current dir and current branch
-- map('t', '<esc><esc>', '<c-\\><c-n>', opts, 'Escape terminal mode') -- seems to conflict with fzf-lua
