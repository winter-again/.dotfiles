local Cmp = {
    "hrsh7th/nvim-cmp",
    version = false,
    lazy = false,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "saadparwaiz1/cmp_luasnip", -- snippet cmp integration
        "onsails/lspkind.nvim", -- completion menu icons
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
            -- ensure friendly-snippets is a dep
            -- lazy_load to speed up startup time
            dependencies = {
                "rafamadriz/friendly-snippets",
                config = function()
                    -- require('luasnip.loaders.from_vscode').lazy_load()
                end,
            },
            config = function()
                local ls = require("luasnip")
                require("luasnip.loaders.from_lua").load({
                    paths = { "~/.config/nvim/lua/winteragain/snippets" },
                })
                ls.setup({
                    update_events = { "TextChanged", "TextChangedI" },
                })

                -- vim.keymap.set({ 'i', 's' }, '<C-k>', function()
                --     if ls.expand_or_jumpable() then
                --         ls.expand_or_jump()
                --     end
                -- end)
                vim.keymap.set({ "i", "s" }, "<C-h>", function()
                    ls.jump(-1)
                end, { silent = true, desc = "Jump to previous snippet node" })
                vim.keymap.set({ "i", "s" }, "<C-l>", function()
                    ls.jump(1)
                end, { silent = true, desc = "Jump to next snippet node" })
            end,
        },
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        cmp.setup({
            sources = cmp.config.sources({
                -- order determines suggestion order
                -- can use keyword_length to change when auto completion gets triggered
                { name = "nvim_lsp" },
                { name = "lazydev", group_index = 0 },
                { name = "luasnip" },
                { name = "path" },
                { name = "buffer", max_item_count = 4 },
                { name = "nvim_lsp_signature_help" },
            }),
            --- @diagnostic disable: missing-fields
            formatting = {
                fields = { "abbr", "kind", "menu" }, -- what fields show in completion item
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    menu = {
                        nvim_lsp = "[LSP]",
                        luasnip = "[snip]",
                        path = "[path]",
                        buffer = "[buf]",
                        cmdline = "[cmd]",
                    },
                    maxwidth = 50,
                    ellipsis_char = "...",
                    -- called before lspkind does any mods; can put other customization here
                    -- before = function(entry, vim_item)
                    --     return vim_item
                    -- end,
                }),
            },
            -- required: specify a snippet engine
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            preselect = cmp.PreselectMode.None, -- don't preselect
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            experimental = {
                ghost_text = false,
            },
            performance = {
                max_view_entries = 10,
            },
            -- copied from TJ; currently no docs so would have to read source for explanation
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
            mapping = cmp.mapping.preset.insert({
                -- avoid inserting the text of selected item until confirmed
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                -- ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-y>"] = cmp.config.disable,
                ["<C-e>"] = cmp.mapping.abort(),
                -- nav snippet expansion locs
                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { "i", "s" }),
                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { "i", "s" }),
            }),
        })
        -- use buffer source for '/' and '?'
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "nvim_lsp_document_symbol" },
            }, {
                { name = "buffer" },
            }),
        })
        -- use cmdline & path sources for ':'
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
            }),
        })
        cmp.setup.filetype("DressingInput", {
            sources = cmp.config.sources({ { name = "omni" } }),
        })
    end,
}

local blink = {
    "saghen/blink.cmp",
    enabled = false,
    dependencies = {
        "onsails/lspkind.nvim", -- completion menu icons
    },
    version = "1.*",
    opts = {
        keymap = { preset = "enter" },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
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
                    auto_insert = true,
                },
            },
            menu = {
                border = "none",
                min_width = 15,
                max_height = 10,
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind", gap = 1, "source_name" },
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local lspkind = require("lspkind")
                                local icon = ctx.kind_icon
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        icon = dev_icon
                                    end
                                else
                                    icon = lspkind.symbolic(ctx.kind, {
                                        mode = "symbol",
                                    })
                                end

                                return icon .. ctx.icon_gap
                            end,
                            -- Optionally, use the highlight groups from nvim-web-devicons
                            -- You can also add the same function for `kind.highlight` if you want to
                            -- keep the highlight groups in sync with the icons.
                            highlight = function(ctx)
                                local hl = ctx.kind_hl
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end

                                return hl
                            end,
                        },
                        kind = {
                            ellipsis = true,
                            width = { fill = true },
                            text = function(ctx)
                                return ctx.kind
                            end,
                            highlight = function(ctx)
                                return ctx.kind_hl
                            end,
                        },
                        source_name = {
                            text = function(ctx)
                                return "[" .. ctx.source_name .. "]"
                            end,
                        },
                    },
                },
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
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
                },
                cmdline = {
                    name = "cmd",
                },
            },
        },
        cmdline = {
            enabled = true,
            -- use 'inherit' to inherit mappings from top level `keymap` config
            keymap = { preset = "cmdline" },
            sources = function()
                local type = vim.fn.getcmdtype()
                -- Search forward and backward
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                -- Commands
                if type == ":" or type == "@" then
                    return { "cmdline" }
                end
                return {}
            end,
            completion = {
                trigger = {
                    show_on_blocked_trigger_characters = {},
                    show_on_x_blocked_trigger_characters = {},
                },
                list = {
                    selection = {
                        -- When `true`, will automatically select the first item in the completion list
                        preselect = false,
                        -- When `true`, inserts the completion item automatically when selecting it
                        auto_insert = true,
                    },
                },
                -- Whether to automatically show the window when new completion items are available
                menu = { auto_show = true },
                -- Displays a preview of the selected item on the current line
                ghost_text = { enabled = false },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = {
            enabled = true,
            window = { border = "none" },
        },
    },
    opts_extend = { "sources.default" },
}

return Cmp
