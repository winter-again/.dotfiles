vim.g.netrw_winsize = 20 -- size for splits
vim.g.netrw_banner = 0 -- disable netrw banner
vim.g.netrw_liststyle = 3 -- tree style view

vim.o.winborder = "solid" -- global border setting; "none", "single", and "solid" are good choices
vim.o.confirm = true -- ask whether to save unsaved changes

local opt = vim.opt

opt.spelllang = "en_us"
-- default spellfile loc; dir must exist
opt.spellfile = vim.fn.stdpath("data") .. "/spell/en.utf-8.add"
-- opt.guicursor = "" -- disable cursor change on mode change
opt.background = "dark"
opt.inccommand = "split" -- preview substitutions live
-- opt.winbar = "%{%v:lua.Winbar()%}" -- disable if using incline.nvim
-- (pseudo)transparency for cmp menu and I guess wildmenu (0 = fully opaque, 100 = fully transparent)
-- doesn't apply to documentation, which is nice
-- note: setting it means cmp menu has highlight but can see text behind
-- not setting + having transparent bg makes just the transparent background show
-- opt.pumblend = 35
opt.mouse = "a" -- enable mouse mode always
opt.equalalways = false -- don't reset window sizes after closing one
opt.showmode = false -- don't show mode in status line
opt.swapfile = false -- turn off swapfiles
opt.backup = false -- turn off backups
opt.undofile = true -- save/restore undo history from file
opt.number = true
opt.relativenumber = true
opt.cursorline = true
-- tab settings
opt.tabstop = 4 -- how wide tab characters are
opt.softtabstop = 4 -- how Tab and Backspace should operate (look and feel while editing)
opt.shiftwidth = 4 -- number of spaces to use for autoindent
opt.expandtab = true -- use only space characters in your files; i.e., using Tab inserts spaces
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
opt.foldenable = false
opt.fillchars:append({ eob = " " }) -- don't use "~" for filling
-- what gets saved in sessions
opt.sessionoptions = "buffers,curdir,help,winpos,winsize"
