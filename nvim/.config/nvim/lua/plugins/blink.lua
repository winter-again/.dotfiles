local kind_icons = require("winter-again.icons").kind

return {
    "saghen/blink.cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
        -- "brenoprata10/nvim-highlight-colors",
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
            kind_icons = kind_icons,
        },
        completion = {
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
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind", gap = 2, "source_name" },
                    },
                    padding = 0,
                    components = {
                        kind_icon = {
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

                                -- Set the highlight priority to below cursorline's default priority of 10000
                                -- Should allow cursorline hl to win, preventing box around kind icon
                                -- return { { group = ctx.kind_hl, priority = 9000 } }
                            end,
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                treesitter_highlighting = true,
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
                            return 2
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
