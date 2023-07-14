return {
    'neovim/nvim-lspconfig',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip', -- luasnip source
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer', -- buffer source
        'hrsh7th/cmp-path', -- path source
        'hrsh7th/cmp-cmdline', -- command source
        -- 'lukas-reineke/cmp-rg', -- ripgrep for buffer source
        'chrisgrieser/cmp-nerdfont', -- nerdfont icons source
        -- 'David-Kunz/cmp-npm', -- npm source
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'onsails/lspkind.nvim', -- completion menu icons
        'glepnir/lspsaga.nvim'
    },
    config = function()
        -- must set up these plugins this order:
        -- 1) mason.nvim
        -- 2) mason-lspconfig.nvim
        -- 3) lspconfig server setup

        -- but I believe this needs to be setup BEFORE anything from lspconfig
        require('neodev').setup()

        -- mason setup
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
        -- mason-lspconfig setup
        require('mason-lspconfig').setup({
            -- make sure these LSPs are installed
            ensure_installed = {
                'lua_ls',
                'pyright',
                'r_language_server',
                'html',
                'cssls',
                'tsserver',
                'eslint',
                'jsonls',
                'astro',
                'emmet_ls',
                'sqlls',
                'marksman',
                'bashls'
            },
            automatic_installation = false -- don't autoinstall
        })
        -- override capabilities sent to server so nvim-cmp can provide its own 
        -- additionally supported candidates
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities({
            dynamicRegistration = false,
            lineFoldingOnly = true
        })

        -- setup LSP via a mix of Mason's extended functionality
        -- and lspconfig
        local lspconfig = require('lspconfig')
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
        -- don't use virtual text for LSP diagnostics
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            float = {border='rounded'},
            underline = true,
            severity_sort = true
        })
        -- if using below setup functionality, shouldn't use direct setup from lspconfig
        -- ref here: https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/mason-lspconfig.txt
        -- addtional override configs for servers go in below table
        -- gets passed to the `settings` field of server config
        -- use server name as the key
        local servers = {
            lua_ls = {
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
                    }
                }
            }
        }
        require('mason-lspconfig').setup_handlers({
            -- default handler called for each installed server that doesn't have a dedicated
            -- handler
            function(server_name)
                -- lspconfig setup in here
                lspconfig[server_name].setup({
                    -- on_attach = lsp_attach,
                    capabilities = lsp_capabilities,
                    settings = servers[server_name]
                })
            end
        })

        -- nvim-cmp setup
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lspkind = require('lspkind')

        luasnip.config.setup()

        cmp.setup({
            -- required: need to specify a snippet engine
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            preselect = cmp.PreselectMode.None, -- don't preselect
            completion = {
                -- set separately from nvim's native completeopt?
                -- completeopt = 'menuone,noselect,noinsert'
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            },
            formatting = {
                fields = {'abbr', 'kind', 'menu'}, -- what fields show in completion item
                -- use lspkind here
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    -- to also show source of the completion items
                    menu = ({
                        -- should match sources
                        nvim_lsp = '[LSP]',
                        luasnip = '[LuaSnip]',
                        path = '[Path]',
                        buffer = '[Buf]',
                        rg = '[Ripgrep]',
                        cmdline = '[Cmd]',
                        nerdfont = '[NerdFont]',
                        otter = '[Otter]'
                    }),
                    maxwidth = 50,
                    ellipsis_char = '...',
                    -- called before lspkind does any mods; can put other customization here
                    before = function(entry, vim_item)
                        return vim_item
                    end
                })
            },
            performance = {
                max_view_entries = 10
            },
            sources = cmp.config.sources({
                -- order determines suggestion order too
                -- can use keyword_length to change when auto completion gets triggered
                {name = 'nvim_lsp'},
                {name = 'luasnip'},
                {name = 'path'},
                {name = 'buffer'},
                {name = 'rg'},
                {name = 'nvim_lsp_signature_help'},
                {name = 'nerdfont'},
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
                -- scroll through completion menu's hover docs
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<CR>'] = cmp.mapping.confirm({select=false}), -- only confirm explicitly selected
                ['<C-y'] = cmp.config.disable,
                ['<C-e>'] = cmp.mapping.abort() -- close completion menu and cancel completion

            })
        })
        -- '/' cmdline setup
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                {name = 'buffer'}
            }
        })
        -- ':' cmdline setup
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
