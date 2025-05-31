local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- set mapleader and maplocalleader before loading lazy.nvim for mappings to be correct
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("winteragain.settings")
require("winteragain.autocmds")
require("winteragain.globals")
require("winteragain.keymaps")

-- use markdown parser for mdx files
-- vim.treesitter.language.register("markdown", { "mdx" })

-- any file in lua/plugins/*.lua will be merged into the main plugin spec
local lazy_opts = {
    dev = {
        path = "~/Documents/code/nvim-dev",
    },
    install = {
        -- try to load one of these when installing during startup
        colorscheme = { "winter-again", "mellifluous" },
    },
    ui = {
        border = "none",
    },
    checker = {
        enabled = false,
        notify = false,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
}
require("lazy").setup({
    { import = "plugins" },
}, lazy_opts)

-- local function colorize(cs_idx)
--     local colorschemes = {
--         -- muted
--         "winter-again",
--         "mellifluous",
--         "vague",
--         "kanagawa-paper",
--         "posterpole",
--         "lackluster-hack",
--         -- heavier contrast
--         "tokyonight",
--         "catppuccin",
--         "rose-pine",
--         "kanagawa",
--     }
--     vim.cmd("colorscheme " .. colorschemes[cs_idx])
--     vim.cmd("Transp")
-- end

-- colorize(1)
vim.cmd("colorscheme winter-again")
