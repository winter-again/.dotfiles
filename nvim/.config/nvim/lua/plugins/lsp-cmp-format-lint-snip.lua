--- @diagnostic disable: missing-fields
return {
    {
        'neovim/nvim-lspconfig',
        -- event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            'folke/neodev.nvim',
        },
        config = function()
            -- must set up these plugins this order:
            -- 1) mason.nvim
            -- 2) mason-lspconfig.nvim
            -- 3) mason-tool-installer.nvim
            -- 4) lspconfig server setup -> I opt to use something from mason-lspconfig instead
            require('neodev').setup() -- neodev needs to be setup BEFORE lspconfig
            -- (1)
            require('mason').setup({
                ui = {
                    border = 'rounded',
                    icons = {
                        package_installed = '✓',
                        package_pending = '➜',
                        package_uninstalled = '✗',
                    },
                },
            })

            -- (2)
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'ansiblels',
                    'astro',
                    'bashls',
                    'cssls',
                    'dockerls',
                    'eslint',
                    'gopls',
                    'html',
                    'jsonls',
                    'lua_ls',
                    'marksman',
                    'pyright',
                    'r_language_server',
                    -- 'ruff_lsp',
                    'sqlls',
                    'tailwindcss',
                    'taplo',
                    'tsserver',
                    'yamlls',
                },
                automatic_installation = false,
            })

            -- (3)
            require('mason-tool-installer').setup({
                auto_update = true,
                debounce_hours = 24,
                ensure_installed = {
                    'black',
                    'isort',
                    'prettierd',
                    'sqlfluff',
                    'stylua',
                    -- 'yamlfix',
                },
            })

            -- (4) see docs: https://github.com/williamboman/mason-lspconfig.nvim/blob/09be3766669bfbabbe2863c624749d8da392c916/doc/mason-lspconfig.txt#L157
            -- override capabilities sent to server so nvim-cmp can provide its own additionally supported candidates
            local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
            lsp_capabilities = require('cmp_nvim_lsp').default_capabilities(lsp_capabilities)
            -- for nvim-ufo
            lsp_capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }

            -- global keymaps
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

            -- keymaps defined on attach
            -- some are replaced with lsp saga alternative
            local function on_attach(_, bufnr)
                local nmap = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = bufnr, silent = true, desc = desc })
                end
                nmap('K', vim.lsp.buf.hover, 'Hover docs')
                -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Sig. help')
                nmap('<leader><leader>rn', vim.lsp.buf.rename, 'LSP def. rename') -- default rename
                -- nmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')

                nmap('gl', vim.diagnostic.open_float, 'Get diagn.')
                nmap('gd', require('telescope.builtin').lsp_definitions, 'Get defn.')
                nmap('gr', require('telescope.builtin').lsp_references, 'Get refs.')
                nmap('gi', require('telescope.builtin').lsp_implementations, 'Get imps.')

                nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type defns.')
                nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Doc symbols')
                nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')
            end

            -- see here for configs:
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            -- handlers should be a table where keys are lspconfig server name and values are setup function
            -- pass default handler by providing func w/ no key
            local handlers = {
                -- default handler called for each installed server
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilties = lsp_capabilities,
                        on_attach = on_attach,
                    })
                end,
                -- override default handler per server
                ['cssls'] = function()
                    lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
                    require('lspconfig')['cssls'].setup({
                        capabilities = lsp_capabilities,
                        on_attach = on_attach,
                    })
                end,
                -- ['eslint'] = function()
                --     require('lspconfig')['eslint'].setup({
                --         capabilities = lsp_capabilities,
                --         -- this should only start eslint if the given config files are found
                --         root_dir = require('lspconfig').util.root_pattern('.eslintrc.js', 'eslint.config.js'),
                --         -- on_attach = on_attach,
                --     })
                -- end,
                ['html'] = function()
                    lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
                    require('lspconfig')['html'].setup({
                        capabilities = lsp_capabilities,
                        on_attach = on_attach,
                    })
                end,
                ['jsonls'] = function()
                    lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
                    require('lspconfig')['jsonls'].setup({
                        capabilities = lsp_capabilities,
                        on_attach = on_attach,
                        -- init_options = {
                        --     provideFormatter = false, -- whether to provide documentRangeFormattingProvider capability on init
                        -- },
                    })
                end,
                ['lua_ls'] = function()
                    require('lspconfig')['lua_ls'].setup({
                        capabilities = lsp_capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT',
                                },
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file('', true),
                                    checkThirdParty = false,
                                },
                                telemetry = {
                                    enable = false,
                                },
                                -- for neodev
                                completion = {
                                    callSnippet = 'Replace',
                                },
                            },
                        },
                    })
                end,
                -- ['ruff_lsp'] = function()
                --     require('lspconfig')['ruff_lsp'].setup({
                --         capabilities = lsp_capabilities,
                --         on_attach = function(client, bufnr)
                --             on_attach(client, bufnr)
                --
                --             -- defer to pyright for textDocument/hover capabilities
                --             client.server_capabilities.hoverProvider = false
                --             -- autocommand for sorting imports with ruff via its code action
                --             local group = vim.api.nvim_create_augroup('RuffSortImportsOnSave', { clear = true })
                --             vim.api.nvim_create_autocmd('BufWritePre', {
                --                 buffer = bufnr,
                --                 callback = function()
                --                     vim.lsp.buf.code_action({
                --                         context = { only = { 'source.organizeImports' } },
                --                         apply = true,
                --                     })
                --                     vim.wait(100)
                --                 end,
                --             })
                --         end,
                --     })
                -- end,
            }
            require('mason-lspconfig').setup_handlers(handlers)

            -- lspconfig appearance and behavior
            -- global floating window borders:
            local orig_util_open_float_prev = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = 'rounded'
                return orig_util_open_float_prev(contents, syntax, opts, ...)
            end

            local sign_icons = {
                Error = '',
                error = '',
                Warn = '',
                warn = '',
                Hint = '',
                hint = '',
                Info = '',
                info = '',
            }
            for type, icon in pairs(sign_icons) do
                local hl = 'DiagnosticSign' .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            local function diagn_format(diagnostic)
                return string.format(
                    '%s [%s]  %s',
                    diagnostic.message or '',
                    diagnostic.source or '',
                    diagnostic.code or diagnostic.user_data or ''
                )
            end
            vim.diagnostic.config({
                virtual_text = {
                    spacing = 4,
                    prefix = '',
                    format = diagn_format,
                },
                float = {
                    border = 'rounded',
                    prefix = ' ',
                    suffix = '', -- get rid of the code that is shown by default since format func handles it
                    format = diagn_format,
                },
                signs = true,
                underline = false,
                update_in_insert = false, -- update diagnostics while in Insert mode
                severity_sort = true,
            })
        end,
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
            'onsails/lspkind.nvim', -- completion menu icons
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
                    end,
                },
                preselect = cmp.PreselectMode.None, -- don't preselect
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    fields = { 'abbr', 'kind', 'menu' }, -- what fields show in completion item
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        -- to also show source of the completion items
                        menu = {
                            -- define labels
                            nvim_lsp = '[LSP]',
                            luasnip = '[LuaSnip]',
                            path = '[path]',
                            buffer = '[buf]',
                            cmdline = '[cmd]',
                            otter = '[otter]',
                        },
                        maxwidth = 50,
                        ellipsis_char = '...',
                        -- called before lspkind does any mods; can put other customization here
                        -- before = function(entry, vim_item)
                        --     return vim_item
                        -- end,
                    }),
                },
                performance = {
                    max_view_entries = 10,
                },
                sources = cmp.config.sources({
                    -- order determines suggestion order
                    -- can use keyword_length to change when auto completion gets triggered
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer', max_item_count = 4 },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'otter' },
                }),
                -- copied from TJ; currently no docs so would have to read source for explanation
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,

                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find('^_+')
                            local _, entry2_under = entry2.completion_item.label:find('^_+')
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
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    ['<C-y>'] = cmp.config.disable,
                    ['<C-e>'] = cmp.mapping.abort(),
                }),
            })
            -- use buffer source for '/' and '?'
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })
            -- use cmdline & path sources for ':'
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                }, {
                    { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
                }),
            })
            -- automatically insert parentheses after cmp selection (functions/method items)
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    css = { 'prettierd' },
                    html = { 'prettierd' },
                    javascript = { 'prettierd' },
                    javascriptreact = { 'prettierd' },
                    -- disabling to let jsonls handle formatting
                    -- so we don't have to constantly set overrides in a .prettierrc.json
                    -- json = { 'prettierd' },
                    lua = { 'stylua' },
                    -- if using ruff_lsp I think can just leave python key out and it should fallback
                    -- to ruff_lsp
                    python = { 'isort', 'black' }, -- run sequentially
                    typescript = { 'prettierd' },
                    typescriptreact = { 'pretterd' },
                },
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    return { timeout_ms = 500, lsp_fallback = true }
                end,
            })

            -- manually trigger formatting
            vim.keymap.set('n', '<leader><leader>fm', function()
                require('conform').format({ async = true, lsp_fallback = true })
            end, { silent = true })
            -- user commands for toggling autoformatting on save
            vim.api.nvim_create_user_command('FormatDisable', function(args)
                if args.bang then
                    -- FormatDisable! will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {
                desc = 'Disable autoformat-on-save',
                bang = true,
            })
            vim.api.nvim_create_user_command('FormatEnable', function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {
                desc = 'Re-enable autoformat-on-save',
            })
        end,
    },
    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('lint').linters_by_ft = {
                javascript = { 'eslint' },
                javascriptreact = { 'eslint' },
                typescript = { 'eslint' },
                typescriptreact = { 'eslint' },
                markdown = {}, -- disables default linting
            }

            -- autocommand that triggers linting
            local lint_group = vim.api.nvim_create_augroup('Lint', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
                group = lint_group,
                callback = function()
                    -- ignore command-not-found errors, e.g., for eslint when no config file
                    -- see: https://github.com/mfussenegger/nvim-lint/issues/272
                    -- and: https://github.com/mfussenegger/nvim-lint/issues/454
                    require('lint').try_lint(nil, { ignore_errors = true })
                end,
            })

            -- manually trigger linting
            vim.keymap.set('n', '<leader><leader>l', function()
                require('lint').try_lint()
            end, { silent = true })
        end,
    },
    {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        -- ensure friendly-snippets is a dep
        -- lazy_load to speed up startup time
        dependencies = {
            'rafamadriz/friendly-snippets',
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end,
        },
        config = function()
            require('luasnip').setup({
                update_events = { 'TextChanged', 'TextChangedI' },
            })

            vim.keymap.set({ 'i', 's' }, '<C-n>', function()
                require('luasnip').jump(1)
            end, { silent = true })
            vim.keymap.set({ 'i', 's' }, '<C-p>', function()
                require('luasnip').jump(-1)
            end, { silent = true })
        end,
    },
}
