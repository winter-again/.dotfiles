local map = require("winteragain.globals").map
local parsers = {
    -- these 7 parsers MUST be installed
    required = {
        "c",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
    },
    "astro",
    "bash",
    "css",
    "csv",
    "desktop",
    "devicetree",
    "dockerfile",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "html",
    "ini",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "just",
    "latex",
    "luadoc",
    "printf",
    "python",
    "r",
    "rasi",
    "regex",
    "rust",
    "sql",
    "ssh_config",
    "svelte",
    "tmux",
    "toml",
    "tsx",
    "typescript",
    "typst",
    "udev",
    "yaml",
    "zathurarc",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            ts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site", -- default loc
            })
            parsers = vim.iter(vim.tbl_values(parsers)):flatten():totable()
            ts.install(parsers)

            -- use markdown parser for mdx files
            vim.treesitter.language.register("markdown", { "mdx" })

            local au_group = vim.api.nvim_create_augroup("winter.again.treesitter", { clear = true })
            vim.api.nvim_create_autocmd({ "FileType" }, {
                group = au_group,
                pattern = parsers,
                desc = "Enable treesitter highlights and indentation support",
                callback = function(event)
                    local filetype = event.match
                    local lang = vim.treesitter.language.get_lang(filetype) -- returns filetype if nothing registered
                    --- @diagnostic disable: param-type-mismatch
                    if vim.treesitter.language.add(lang) then
                        local bufnr = event.buf
                        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        vim.treesitter.start(bufnr, lang)
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter-textobjects").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                    },
                    move = {
                        set_jumps = true,
                    },
                },
            })

            local function select(textobj)
                return function()
                    require("nvim-treesitter-textobjects.select").select_textobject(textobj, "textobjects")
                end
            end
            local opts = { silent = true }
            map({ "x", "o" }, "af", select("@function.outer"), opts, "Select around function")
            map({ "x", "o" }, "if", select("@function.inner"), opts, "Select inside function")
            map({ "x", "o" }, "ac", select("@class.outer"), opts, "Select around class")
            map({ "x", "o" }, "ic", select("@class.inner"), opts, "Select inside class")
            -- trying to capture markdown fenced code blocks/content
            -- seems to behave incorrectly when there's a Python function defn in the block
            -- 'vib' fails to include the function defn. line
            -- or at least it behaves strangely dep on cursor loc in the block...
            map({ "x", "o" }, "ab", select("@codeblock.outer"), opts, "Select around code block")
            map({ "x", "o" }, "ib", select("@codeblock.inner"), opts, "Select inside code block")

            local function goto_next(textobj)
                return function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(textobj, "textobjects")
                end
            end
            local function goto_prev(textobj)
                return function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start(textobj, "textobjects")
                end
            end
            map({ "n", "x", "o" }, "]f", goto_next("@function.outer"), opts, "Next function")
            map({ "n", "x", "o" }, "[f", goto_prev("@function.outer"), opts, "Previous function")
            map({ "n", "x", "o" }, "]b", goto_next("@codeblock.outer"), opts, "Next codeblock")
            map({ "n", "x", "o" }, "[b", goto_prev("@codeblock.outer"), opts, "Previous codeblock")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                multiwindow = true,
                max_lines = 2,
                line_numbers = true,
                on_attach = function(bufnr)
                    -- disable b/c poor scrolling perf in markdown
                    return vim.bo[bufnr].filetype ~= "markdown"
                end,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
            })
        end,
    },
}
