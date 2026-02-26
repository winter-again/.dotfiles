--- @diagnostic disable: missing-fields
return {
    {
        'neovim/nvim-lspconfig',
        event = {'BufReadPre', 'BufNewFile'},
	    enabled = true,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim'
        },
        config = function()
            -- must set up these plugins this order:
            -- 1) mason.nvim
            -- 2) mason-lspconfig.nvim
            -- 3) lspconfig server setup -> I opt to use something from mason-lspconfig instead
            require('neodev').setup() -- neodev needs to be setup BEFORE lspconfig
            -- (1)
            require('mason').setup({
                ui = {
                    border = 'rounded',
                    icons = {
                        package_installed = '✓',
                        package_pending = '➜',
                        package_uninstalled = '✗'
                    }
                }
            })
            -- (2)
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'pyright',
                    -- 'ruff_lsp',
                    'r_language_server',
                    'gopls',
                    'html',
                    'emmet_ls',
                    'cssls',
                    'tsserver',
                    'eslint',
                    'astro',
                    'jsonls',
                    'sqlls',
                    'marksman',
                    'bashls',
                    'taplo',
                    'yamlls'
                },
                automatic_installation = false
            })

            local handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,
                ['lua_ls'] = function()
                    require('lspconfig')['lua_ls'].setup({
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT'
                                },
                                diagnostics = {
                                    globals = {'vim'}
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file('', true),
                                    checkThirdParty = false
                                },
                                telemetry = {
                                    enable = false
                                },
                                -- for neodev
                                completion = {
                                    callSnippet = 'Replace'
                                }
                            }
                        }
                    })
                end,
                -- ['ruff_lsp'] = function()
                --     require('lspconfig')['ruff_lsp'].setup({
                --         on_attach = function(client, bufnr)
                --             client.server_capabilities.hoverProvider = false
                --         end
                --     })
                -- end
            }
            -- override capabilities sent to server so nvim-cmp can provide its own additionally supported candidates
            local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
            lsp_capabilities = require('cmp_nvim_lsp').default_capabilities(lsp_capabilities)
            -- from nvim-ufo
            lsp_capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            require('mason-lspconfig').setup_handlers(handlers)

            -- lspconfig appearance and behavior
            require('lspconfig.ui.windows').default_options.border = 'rounded'
            -- modify diagnostic sign icons
            -- I think lowercase name is for statusline and uppercase is for actual sign column?
            local sign_icons = {
                Error = '',
                error = '',
                Warn = '',
                warn = '',
                Hint = '',
                hint = '',
                Info = '',
                info = ''
            }
            for type, icon in pairs(sign_icons) do
                local hl = 'DiagnosticSign' .. type
                vim.fn.sign_define(hl, {text=icon, texthl=hl, numhl=hl})
            end
            vim.diagnostic.config({
                virtual_text = false, -- don't use virtual text for LSP diagnostics
                signs = true,
                float = {border='rounded'},
                underline = false,
                severity_sort = true
            })
        end
    },
    {
        'L3MON4D3/LuaSnip', -- snippet engine
        version = '2.*',
        -- ensure friendly-snippets is a dep
        -- lazy_load to speed up startup time
        dependencies = {
            'rafamadriz/friendly-snippets',
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end
        },
        config = true
    },
    {
        'hrsh7th/nvim-cmp',
        version = false,
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'saadparwaiz1/cmp_luasnip', -- snippet cmp integration
            'onsails/lspkind.nvim' -- completion menu icons
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            cmp.setup({
                -- required: specify a snippet engine
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                preselect = cmp.PreselectMode.None, -- don't preselect
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                formatting = {
                    fields = {'abbr', 'kind', 'menu'}, -- what fields show in completion item
                    -- config lspkind
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        -- to also show source of the completion items
                        menu = ({
                            -- define labels
                            nvim_lsp = '[LSP]',
                            luasnip = '[LuaSnip]',
                            path = '[path]',
                            buffer = '[buf]',
                            cmdline = '[cmd]',
                            otter = '[otter]'
                        }),
                        maxwidth = 50,
                        ellipsis_char = '...',
                        -- called before lspkind does any mods; can put other customization here
                        -- before = function(entry, vim_item)
                        --     return vim_item
                        -- end
                    })
                },
                performance = {
                    max_view_entries = 10
                },
                sources = cmp.config.sources({
                    -- order determines suggestion order
                    -- can use keyword_length to change when auto completion gets triggered
                    {name = 'nvim_lsp'},
                    {name = 'luasnip'},
                    {name = 'path'},
                    {name = 'buffer'},
                    {name = 'nvim_lsp_signature_help'},
                    {name = 'otter'},
                }),
                -- copied from TJ; currently no docs so would have to read source for explanation
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,

                        function(entry1, entry2)
                        local _, entry1_under = entry1.completion_item.label:find "^_+"
                        local _, entry2_under = entry2.completion_item.label:find "^_+"
                        entry1_under = entry1_under or 0
                        entry2_under = entry2_under or 0
                        if entry1_under > entry2_under then
                          return false
                        elseif entry1_under < entry2_under then
                          return true
                        end
                        end,

                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                        },
                },
                mapping = cmp.mapping.preset.insert({
                    -- avoid inserting the text of selected item until confirmed
                    ['<C-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
                    ['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<CR>'] = cmp.mapping.confirm({behavior=cmp.ConfirmBehavior.Replace, select=false}),
                    ['<C-y>'] = cmp.config.disable,
                    ['<C-e>'] = cmp.mapping.abort()

                })
            })
            -- use buffer source for '/' and '?'
            cmp.setup.cmdline({'/', '?'}, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    {name = 'buffer'}
                }
            })
            -- use cmdline & path sources for ':'
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    {name = 'path'}
                }, {
                    {name = 'cmdline', option = {ignore_cmds = {'Man', '!'}}}
                })
            })
            -- automatically insert parentheses after cmp selection (functions/method items)
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
            end
    }
}
