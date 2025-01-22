if vim.g.vscode then
    -- NOTE: settings restricted to VSCode extension
    -- load in just settings and keymaps in VSCode
    -- not sure how safe
    require("winteragain.settings")
    require("winteragain.keymaps")
else
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- use markdown parser for mdx files
    -- vim.treesitter.language.register("markdown", { "mdx" })

    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    ---@diagnostic disable-next-line undefined-field
    vim.opt.rtp:prepend(lazypath)

    -- NOTE: consider moving these "default" things to plugin/ dir
    -- (automatically sourced after lazy config loaded)
    -- advantage of current way is that I have finer control
    -- over what gets required and the order
    require("winteragain.settings")
    require("winteragain.autocmds")
    require("winteragain.globals")
    require("winteragain.keymaps")

    -- get plugin specs from their individual files in the plugins directory
    -- any file in lua/plugins/*.lua will be merged into the main plugin spec
    -- require('lazy').setup('plugins', lazy_opts)
    local lazy_opts = {
        dev = {
            path = "~/Documents/code/nvim-dev",
        },
        install = {
            colorscheme = { "winter-again", "mellifluous", "tokyonight" }, -- try to load one of these colorschemes when starting an installation during startup
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
    -- to load subdirs of lua/plugins
    -- have to import the dirs
    require("lazy").setup({
        { import = "plugins" },
        { import = "plugins.code" },
        { import = "plugins.git" },
    }, lazy_opts)

    ---Set colorscheme and transparent background
    ---@param cs_idx number
    local function colorize(cs_idx)
        local colorschemes = {
            -- muted
            "mellifluous",
            "vague",
            "kanagawa-paper",
            "posterpole",
            "lackluster-hack",
            -- heavier contrast
            "tokyonight",
            "catppuccin",
            "rose-pine",
            "kanagawa",
            "winter-again",
        }
        vim.cmd("colorscheme " .. colorschemes[cs_idx])
        vim.cmd("Transp")
    end

    -- colorize(1)
    vim.cmd("colorscheme winter-again")
end
