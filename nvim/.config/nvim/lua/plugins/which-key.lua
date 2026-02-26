return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        local wk = require('which-key')
        local mappings = {
            ['<C-_>'] = {'Toggle comment'},
            ['<C-a>'] = {'Select all'},
            ['<C-Up>'] = {'Make window longer'},
            ['<C-Down>'] = {'Make window shorter'},
            ['<C-Left>'] = {'Make window narrower'},
            ['<C-Right>'] = {'Make window wider'},
            ['<C-h>'] = {'Move left'},
            ['<C-j>'] = {'Move down'},
            ['<C-k>'] = {'Move up'},
            ['<C-l>'] = {'Move right'},
            ['<C-d>'] = {'Half page jump down'},
            ['<C-u>'] = {'Half page jump up'},
            ['<leader>f/'] = {'Find in buffer'},
            ['ci'] = {
                name = 'Quarto code chunks',
                r = 'Insert R code chunk',
                p = 'Insert Python code chunk'
            },
            ['<leader>'] = {
                b = {
                    name = 'Buffers',
                    l = {'Move buffer left in bufferline'},
                    p = {'Pin buffer to bufferline'},
                    r = {'Move buffer right in bufferline'}
                },
                db = {'Delete buffer'},
                f = {
                    name = 'Telescope',
                    b = {'Find buffers'},
                    c = {'Find colorscheme'},
                    D = {'Find workspace diagnostics'},
                    d = {'Find file diagnostics'},
                    f = {'Find file'},
                    m = {'Format file'},
                    gb = {'Find buffer git commits'},
                    gc = {'Find git commits'},
                    gs = {'Find current changes'},
                    h = {'Find highlights'},
                    j = {'Find jumplist'},
                    k = {'Find keymaps'},
                    p = {'Find session'},
                    r = {'Find registers'},
                    s = {'Find string in cwd'},
                    u = {'Find undo tree'},
                    v = {'File browser'},
                },
                g = {
                    name = 'Git',
                    b = {'Git blame toggle'},
                    D = {'Git diff vs. last commit'},
                    d = {'Git diff vs. index'},
                    hs = {'Stage hunk'},
                    hr = {'Reset hunk'},
                    hu = {'Undo stage hunk'},
                    hp = {'Preview hunk'},
                    s = {'Git status'}
                },
                l = {'Remove search highlights'},
                o = {'Transparent bg'},
                p = {
                    name = 'File mgmt',
                    l = {'Last session'},
                    r = {'Restore directory session'},
                    v = {'Toggle NvimTree'},
                },
                q = {
                    name = 'Quarto',
                    p = {'Open Quarto preview'},
                    q = {'Quit Quarto preview'}
                },
                rs = {'Find and replace all for word under cursor'},
                s = {
                    a = {'Split args toggle'},
                    c = {'Send chunk'},
                    f = {'Send file'},
                    h = {'Split horizontally'},
                    i = {'Start REPL here'},
                    l = {'Send line'},
                    s = {'Start REPL'},
                    t = {'Interrupt REPL'},
                    u = {'Send REPL until here'},
                    v = {'Split vertically'}
                },
                t = {
                    name = 'Trouble',
                    t = {'Toggle trouble'},
                    w = {'Toggle workspace trouble'},
                    d = {'Toggle document trouble'}
                },
            },
            ['J'] = {'Append line below to current line'},
            ['n'] = {'Go to next search match'},
            ['N'] = {'Go to previous search match'},
            ['r'] = {'Redo'},
            ['s'] = {
                name = 'Surround',
                s = 'Add surround',
                c = 'Change surround',
                d = 'Delete surround'
            },
            ['z'] = {
                name = 'Folds',
                R = 'Open all folds',
                M = 'Close all folds'
            }
        }
        wk.register(mappings) -- register the mappings
        wk.setup({
            icons = {
                group = '+' -- default; symbol prepended to group names
            },
            window = {
                border = 'single',
                -- winblend = 100 -- control opacity
            }
        })
    end
}
