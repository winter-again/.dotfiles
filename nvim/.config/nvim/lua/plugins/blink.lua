return {
    "saghen/blink.cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "folke/lazydev.nvim",
    },
    version = "1.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "enter",
        },
        appearance = {
            nerd_font_variant = "mono",
            kind_icons = require("winter-again.icons").kind,
        },
        completion = {
            keyword = {
                range = "prefix",
            },
            list = {
                max_items = 5,
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            menu = {
                min_width = 15,
                max_height = 10,
                border = "none",
                scrollbar = false,
                auto_show = true,
                auto_show_delay_ms = 500,
                draw = {
                    align_to = "label",
                    padding = 0,
                    gap = 1,
                    -- treesitter = { "lsp" }, -- use treesitter to highlight label text for these sources (e.g., function colored)
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind", gap = 2, "source_name" },
                    },
                    components = {
                        kind_icon = {
                            -- NOTE: for integration with nvim-highlight-colors
                            text = function(ctx)
                                -- default kind icon
                                local icon = ctx.kind_icon
                                -- if LSP source, check for color derived from documentation
                                if ctx.item.source_name == "LSP" then
                                    local color_item = require("nvim-highlight-colors").format(
                                        ctx.item.documentation,
                                        { kind = ctx.kind }
                                    )
                                    if color_item and color_item.abbr ~= "" then
                                        icon = color_item.abbr
                                    end
                                elseif ctx.item.source_name == "cmd" then
                                    return ""
                                end
                                return icon .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                -- default highlight group
                                local highlight = "BlinkCmpKind" .. ctx.kind
                                -- if LSP source, check for color derived from documentation
                                if ctx.item.source_name == "LSP" then
                                    local color_item = require("nvim-highlight-colors").format(
                                        ctx.item.documentation,
                                        { kind = ctx.kind }
                                    )
                                    if color_item and color_item.abbr_hl_group then
                                        highlight = color_item.abbr_hl_group
                                    end
                                end
                                return highlight
                            end,
                        },
                        kind = {
                            text = function(ctx)
                                if ctx.item.source_name == "cmd" then
                                    return ""
                                end
                                return ctx.kind
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
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                treesitter_highlighting = true,
                window = {
                    scrollbar = false,
                },
            },
        },
        signature = {
            enabled = true,
            trigger = {
                enabled = true,
            },
            window = {
                border = "none",
                show_documentation = false,
                scrollbar = false,
            },
        },
        fuzzy = {
            implementation = "lua", -- "prefer_rust_with_warning"
            sorts = {
                "exact", -- ensure exact matches prioritized
                "score",
                "sort_text",
            },
            prebuilt_binaries = {
                download = false,
            },
        },
        sources = {
            default = {
                "lsp",
                "path",
                "snippets",
                "buffer",
                "lazydev",
            },
            providers = {
                lsp = {
                    name = "LSP",
                    -- max_items = 5,
                },
                path = {
                    name = "path",
                    opts = {
                        show_hidden_files_by_default = true,
                    },
                },
                snippets = {
                    name = "snip",
                    opts = {
                        use_label_description = true,
                    },
                },
                buffer = {
                    name = "buf",
                    -- max_items = 5,
                    -- score_offset = -5,
                },
                cmdline = {
                    name = "cmd",
                    -- min_keyword_length = function(ctx)
                    --     if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                    --         return 2
                    --     end
                    --
                    --     return 0
                    -- end,
                },
                lazydev = {
                    name = "nvim",
                    module = "lazydev.integrations.blink",
                    score_offset = 100, -- make top prio.
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
                -- ["<CR>"] = { "accept_and_enter", "fallback" },
            },
            sources = function()
                local type = vim.fn.getcmdtype()
                -- search forward and backward
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                -- commands
                if type == ":" or type == "@" then
                    return { "cmdline", "buffer" }
                end
                return {}
            end,
            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
                menu = {
                    auto_show = true,
                },
                ghost_text = { enabled = false },
            },
        },
    },
    opts_extend = { "sources.default" },
}
