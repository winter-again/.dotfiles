-- disable Netrw as advised for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Netrw settings
-- vim.g.netrw_winsize = 20
-- vim.g.netrw_banner = 0 -- disable netrw banner
-- vim.g.netrw_liststyle = 3 -- tree style view

local opt = vim.opt

vim.o.winborder = "none"
-- opt.guicursor = "" -- disable cursor change on mode change
-- opt.splitright = true -- new window to the right of current
-- opt.splitbelow = true -- new window below the current
opt.background = "dark"
opt.inccommand = "split" -- preview substitutions live
-- opt.winbar = "%{%v:lua.Winbar()%}" -- disable if using incline.nvim
-- opt.winbar = " " -- otherwise incline.nvim will overlap first line of text
-- (pseudo)transparency for cmp menu and I guess wildmenu (0 = fully opaque, 100 = fully transparent)
-- doesn't apply to documentation, which is nice
-- note: setting it means cmp menu has highlight but can see text behind
-- not setting + having transparent bg makes just the transparent background show
-- opt.pumblend = 35
opt.wildignore = "__pycache__"
---@diagnostic disable-next-line: undefined-field
opt.wildignore:append({ "*.pyc", "*pycache*" })
opt.mouse = "a" -- enable mouse mode always
opt.equalalways = false -- don't reset window sizes after closing one
opt.showmode = false -- don't show mode in status line
opt.swapfile = false -- turn off swapfiles
opt.backup = false -- turn off backups
-- default location is ~/.local/state/nvim/undo/
-- opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
opt.undofile = true -- save undo history to an undo file and restore from too
-- line numbers; setting both of these together gives hybrid line numbering
opt.number = true
opt.relativenumber = true
opt.cursorline = true -- highlight current line and its line number
-- opt.colorcolumn = '80'
-- tab settings
opt.tabstop = 4 -- how wide tab characters are
opt.softtabstop = 4 -- how Tab and Backspace should operate (look and feel while editing)
opt.shiftwidth = 4 -- number of spaces to use for autoindent
opt.expandtab = true -- use only space characters in your files; i.e., using Tab inserts spaces
-- indentation
opt.smartindent = true -- smart autoindenting when starting new line
-- case insensitive searching UNLESS /C or capital in search
opt.smartcase = true -- be smart about case when searching
opt.ignorecase = true -- also set this so that smartcase takes over as needed
opt.wrap = false -- no line wrapping
opt.incsearch = true -- show search result while typing the search term
opt.termguicolors = true -- nice colors
opt.scrolloff = 4 -- always keep at least this number of lines above/below the cursor when scrolling
opt.updatetime = 250 -- faster updatetime for triggering plugins; default is 4000 ms
opt.timeoutlen = 300
opt.laststatus = 3 -- global statusline
-- better completion experience
-- menu = use popup menu to show possible completions
-- menuone = use menu also when there is only one match
-- noselect = don't preselect
opt.completeopt = { "menu", "menuone", "noselect" }
-- opt.signcolumn = 'yes:2' -- fix signcolumn at 2 and always show; does statuscol conflict with this?
-- settings for folding, which is handled by nvim-ufo plugin
opt.foldenable = false
-- opt.foldmethod = 'manual'
-- opt.foldcolumn = '1'
-- opt.foldlevel = 99
-- opt.foldlevelstart = 99
-- opt.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
opt.fillchars:append({ eob = " " })
-- what gets saved in sessions
opt.sessionoptions = "buffers,curdir,winpos,winsize"
