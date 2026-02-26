return {
    "saghen/blink.cmp",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = (function()
                -- build step needed for optional regex support in snipppets
                if vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
            config = function()
                local ls = require("luasnip")

                -- ls.config.setup({
                --     region_check_events = "CursorHold,InsertLeave",
                --     delete_check_events = "TextChanged,InsertEnter",
                -- })

                require("luasnip.loaders.from_lua").lazy_load({
                    paths = { "~/.config/nvim/lua/winteragain/snippets" },
                })

                vim.keymap.set({ "i", "s" }, "<C-h>", function()
                    ls.jump(-1)
                end, { silent = true, desc = "Jump to previous snippet node" })
                vim.keymap.set({ "i", "s" }, "<C-l>", function()
                    ls.jump(1)
                end, { silent = true, desc = "Jump to next snippet node" })
            end,
        },
        "folke/lazydev.nvim",
    },
    version = "1.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "enter",
            ["<Tab>"] = { "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
            kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "󰒓",

                Field = "󰜢",
                Variable = "󰂡",
                Property = "󰜢",

                Class = "󰠱",
                Interface = "",
                Struct = "",
                Module = "󰅩",

                Unit = "󰪚",
                Value = "󰎠",
                Enum = "",
                EnumMember = "",

                Keyword = "󰌋",
                Constant = "󰏿",

                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰬲",
                Folder = "󰉋",
                Event = "󱐋",
                Operator = "󰆕",
                TypeParameter = "󰬛",
            },
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                treesitter_highlighting = true,
            },
            list = {
                max_items = 10,
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            menu = {
                min_width = 15,
                max_height = 10,
                border = "none",
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind", gap = 1, "source_name" },
                    },
                },
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "lazydev" },
            providers = {
                lsp = {
                    name = "LSP",
                    max_items = 5,
                },
                path = {
                    name = "path",
                },
                snippets = {
                    name = "snip",
                },
                buffer = {
                    name = "buf",
                    max_items = 5,
                    score_offset = -5,
                },
                cmdline = {
                    name = "cmd",
                    min_keyword_length = function(ctx)
                        if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                            return 3
                        end

                        return 0
                    end,
                },
                lazydev = {
                    name = "nvim",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
            },
        },
        snippets = {
            preset = "luasnip",
        },
        cmdline = {
            enabled = true,
            keymap = {
                preset = "inherit",
                ["<CR>"] = { "accept_and_enter", "fallback" },
            },
            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
                menu = { auto_show = true },
                ghost_text = { enabled = false },
            },
        },
        fuzzy = {
            implementation = "prefer_rust_with_warning",
            sorts = {
                -- ensure exact matches prioritized
                "exact",
                "score",
                "sort_text",
            },
        },
        signature = {
            enabled = true,
            window = { border = "none", show_documentation = false },
        },
    },
    opts_extend = { "sources.default" },
}
