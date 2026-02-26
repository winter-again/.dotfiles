--- @diagnostic disable: missing-fields
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "astro",
                    "bash",
                    "c",
                    "css",
                    "git_config",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "gomod",
                    "html",
                    "javascript",
                    "json",
                    "latex",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "r",
                    "rasi",
                    "regex",
                    "sql",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                sync_install = false, -- synchronous install of parsers (only applied to ensure_installed)
                auto_install = false, -- recommended to set false if don't have tree-sitter CLI installed locally
                highlight = {
                    enable = true, -- false will disable the whole extension
                },
                indent = {
                    enable = true, -- still experimental; Python supp under dev
                    disable = { "r" },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = { query = "@function.outer", desc = "Around function" },
                            ["if"] = { query = "@function.inner", desc = "Inside function" },
                            ["ac"] = { query = "@class.outer", desc = "Around class" },
                            ["ic"] = { query = "@class.inner", desc = "Inside class" },
                            -- trying to capture markdown fenced code blocks/content
                            -- seems to behave incorrectly when there's a Python function defn in the block
                            -- 'vib' fails to include the function defn. line
                            -- or at least it behaves strangely dep on cursor loc in the block...
                            ["ab"] = { query = "@block.outer", desc = "Around code block" },
                            ["ib"] = { query = "@block.inner", desc = "Inside code block" },
                            ["al"] = { query = "@pipeline_assign", desc = "dplyr pipeline assign" },
                            ["il"] = { query = "@pipe", desc = "dplyr pipe operator" },
                        },
                    },
                    move = {
                        enable = true,
                        goto_next_start = {
                            ["]b"] = "@block.outer",
                        },
                        goto_previous_start = {
                            ["[b"] = "@block.outer",
                        },
                    },
                },
                additional_vim_regex_highlighting = false,
            })
            vim.keymap.set(
                "n",
                "<leader>tsp",
                "<cmd>InspectTree<CR>",
                { silent = true, desc = "Show parsed syntax tree" }
            )
            vim.keymap.set(
                "n",
                "<leader>tsh",
                "<cmd>Inspect<CR>",
                { silent = true, desc = "Show highlight groups under cursor" }
            )
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                max_lines = 2,
            })
        end,
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            vim.g.skip_ts_context_commentstring_module = true -- skip backwards compat checks for faster loading
            require("ts_context_commentstring").setup({})
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "IndianBoy42/tree-sitter-just",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("tree-sitter-just").setup({})
        end,
    },
}
