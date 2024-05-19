--- @diagnostic disable: missing-fields
return {
    {
        'neovim/nvim-lspconfig',
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
            require('mason').setup({
                ui = {
                    -- border = 'solid',
                    icons = {
                        package_installed = '✓',
                        package_pending = '➜',
                        package_uninstalled = '✗',
                    },
                },
            })
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
                    'ruff_lsp',
                    'sqlls',
                    'tailwindcss',
                    'taplo',
                    'tsserver',
                    'yamlls',
                },
                automatic_installation = false,
            })
            require('mason-tool-installer').setup({
                auto_update = true,
                debounce_hours = 24,
                ensure_installed = {
                    'black',
                    -- 'flake8',
                    'isort',
                    'prettierd',
                    'sqlfluff',
                    'selene',
                    'stylua',
                    -- 'yamlfix',
                },
            })
            -- keymaps
            local map = function(mode, lhs, rhs, opts, desc)
                opts = opts or {}
                opts.desc = desc
                vim.keymap.set(mode, lhs, rhs, opts)
            end
            -- default in v0.10
            map('n', '[d', vim.diagnostic.goto_prev, { silent = true }, 'Go to previous diagnostic message')
            map('n', ']d', vim.diagnostic.goto_next, { silent = true }, 'Go to next diagnostic message')
            -- keymaps defined on attach
            local function on_attach(client, bufnr)
                local opts = { silent = true, buffer = bufnr }
                -- default in v0.10
                map('n', 'K', vim.lsp.buf.hover, opts, 'Hover docs')
                map('n', 'gs', function()
                    vim.diagnostic.open_float({ scope = 'cursor' })
                end, opts, 'Get cursor diagnostics')
                map('n', 'gl', function()
                    vim.diagnostic.open_float({ scope = 'line' })
                end, opts, 'Get line diagnostics')
                map('n', 'gd', require('telescope.builtin').lsp_definitions, opts, 'Telescope LSP defns.')
                map('n', 'gD', vim.lsp.buf.declaration, opts, 'Go to declaration')
                map('n', 'gr', require('telescope.builtin').lsp_references, opts, 'Telescope LSP refs.')
                map('n', 'gI', require('telescope.builtin').lsp_implementations, opts, 'Telescope find impls.')
                map('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, opts, 'Telescope type defns.')
                map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, opts, 'Telescope doc symbols')
                map(
                    'n',
                    '<leader>ws',
                    require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    opts,
                    'Telescope workspace symbols'
                )
                map('n', '<leader><leader>rn', vim.lsp.buf.rename, opts, 'LSP default rename') -- default rename w/o fancy pop-up from LspSaga
                map(
                    'n',
                    '<leader>ws',
                    require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    opts,
                    'Telescope workspace symbols'
                )
                map('n', '<leader>ih', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end, opts, 'Toggle inlay hints')
            end

            -- (4) see docs: https://github.com/williamboman/mason-lspconfig.nvim/blob/09be3766669bfbabbe2863c624749d8da392c916/doc/mason-lspconfig.txt#L157
            -- override capabilities sent to server so nvim-cmp can provide its own additionally supported candidates
            local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
            lsp_capabilities = require('cmp_nvim_lsp').default_capabilities(lsp_capabilities)

            -- see here for configs:
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            -- handlers should be a table where keys are lspconfig server name and values are setup function
            -- pass default handler by providing func w/ no key
            local handlers = {
                -- default handler called for each installed server
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = lsp_capabilities,
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
                                hint = { enable = true },
                                runtime = {
                                    version = 'LuaJIT',
                                },
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    -- library = vim.api.nvim_get_runtime_file('', true),
                                    library = {
                                        '${3rd}/luv/library',
                                        unpack(vim.api.nvim_get_runtime_file('', true)),
                                    },
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
                ['tailwindcss'] = function()
                    require('lspconfig')['tailwindcss'].setup({
                        capabilities = lsp_capabilities,
                        -- only run LSP if tailwind config files present
                        root_dir = function(fname)
                            local root_pattern = require('lspconfig').util.root_pattern(
                                'tailwind.config.cjs',
                                'tailwind.config.js',
                                'tailwind.config.mjs',
                                'postcss.config.js'
                            )
                            return root_pattern(fname)
                        end,
                    })
                end,
                ['pyright'] = function()
                    -- remove capabilities that ruff can provide
                    require('lspconfig')['pyright'].setup({
                        -- https://github.com/astral-sh/ruff-lsp/issues/384
                        -- https://www.reddit.com/r/neovim/comments/11k5but/comment/jbjwwtf/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
                        -- not sure about this...
                        capabilities = (function()
                            local capabilities = vim.lsp.protocol.make_client_capabilities()
                            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
                            return capabilities
                        end)(),
                        settings = {
                            pyright = {
                                disableOrganizeImports = true,
                            },
                            -- python = {
                            --     analysis = {
                            --         ignore = { '*' },
                            --     },
                            -- },
                        },
                    })
                end,
                ['ruff_lsp'] = function()
                    require('lspconfig')['ruff_lsp'].setup({
                        capabilities = lsp_capabilities,
                        on_attach = function(client, bufnr)
                            if client.name == 'ruff_lsp' then
                                -- let pyright handle hovering
                                client.server_capabilities.hoverProvider = false
                            end
                            on_attach(client, bufnr)
                            -- autocommand for sorting imports with ruff via its code action
                            -- using ruff-lsp code actions instead of the ruff commands as you would
                            -- with none-ls solution
                            -- https://github.com/astral-sh/ruff-lsp/issues/95 (for snippet below)
                            -- https://github.com/astral-sh/ruff-lsp/issues/119
                            local group = vim.api.nvim_create_augroup('RuffSortImportsOnSave', { clear = true })
                            -- vim.api.nvim_create_autocmd('BufWritePre', {
                            --     group = group,
                            --     buffer = bufnr,
                            --     callback = function()
                            --         vim.lsp.buf.code_action({
                            --             context = { only = { 'source.organizeImports' } },
                            --             apply = true,
                            --         })
                            --         vim.wait(100)
                            --     end,
                            -- })
                            -- adapted from: https://github.com/astral-sh/ruff-lsp/issues/295
                            local ruff_lsp_client =
                                require('lspconfig.util').get_active_client_by_name(bufnr, 'ruff_lsp')
                            local request = function(method, params)
                                ruff_lsp_client.request(method, params, nil, bufnr)
                            end
                            local sort_imports = function()
                                request('workspace/executeCommand', {
                                    command = 'ruff.applyOrganizeImports',
                                    arguments = {
                                        { uri = vim.uri_from_bufnr(bufnr) },
                                    },
                                })
                            end
                            vim.api.nvim_create_autocmd('BufWritePre', {
                                group = group,
                                buffer = bufnr,
                                callback = function()
                                    sort_imports()
                                    vim.wait(100)
                                end,
                            })
                        end,
                    })
                end,
            }
            require('mason-lspconfig').setup_handlers(handlers)

            -- lspconfig appearance and behavior
            -- global floating window borders by replacing the orig. function
            -- see here: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
            local orig_util_open_float_prev = vim.lsp.util.open_floating_preview
            vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
                opts = opts or {}
                -- opts.border = 'rounded'
                return orig_util_open_float_prev(contents, syntax, opts, ...)
            end

            -- custom signs for diagnostics
            -- trouble.nvim can pick these up
            local sign_icons = {
                Error = '',
                Warn = '',
                Info = '',
                Hint = '',
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
                    prefix = '󱓻',
                    format = diagn_format,
                },
                float = {
                    -- border = 'rounded',
                    prefix = '󰉹 ',
                    suffix = '', -- get rid of the code that is shown by default since format func handles it
                    format = diagn_format,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = sign_icons.Error,
                        [vim.diagnostic.severity.WARN] = sign_icons.Warn,
                        [vim.diagnostic.severity.INFO] = sign_icons.Info,
                        [vim.diagnostic.severity.HINT] = sign_icons.Hint,
                    },
                    linehl = {
                        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
                    },
                    numhl = {
                        [vim.diagnostic.severity.WARN] = 'WarningMsg',
                    },
                },
                underline = true,
                update_in_insert = false, -- update diagnostics while in Insert mode
                severity_sort = true,
            })
        end,
    },
    {
        'glepnir/lspsaga.nvim',
        dev = true,
        event = 'LspAttach',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'nvim-treesitter/nvim-treesitter', -- need markdown and markdown_inline parsers
        },
        config = function()
            require('lspsaga').setup({
                ui = {
                    -- border = 'rounded',
                },
                outline = {
                    layout = 'normal',
                    -- layout = 'float',
                },
                finder = {
                    filter = {
                        ['textDocument/references'] = function(client_id, result)
                            -- NOTE: `result` here is { { range = {} } }
                            -- with mod I'm making it { range = {...} } itself
                            -- test func should show only results from scratch.lua this uri when searching
                            -- Winbar() refs
                            -- if result.uri == 'file:///home/andrew/.dotfiles/scratch.lua' then
                            --     return true
                            -- else
                            --     return false
                            -- end
                            return true
                        end,
                    },
                },
                symbol_in_winbar = {
                    enable = false,
                },
                lightbulb = {
                    enable = false,
                },
                scroll_preview = {
                    scroll_down = '<C-f>',
                    scroll_up = '<C-b>',
                },
                code_action = {
                    show_server_name = true,
                },
            })
            -- finder that shows defn, ref, and implementation
            vim.keymap.set('n', '<leader>gf', '<cmd>Lspsaga finder<CR>', { silent = true, desc = 'LspSaga finder' })
            -- rename all references to symbol under cursor
            vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true, desc = 'LspSaga rename' })
            -- code action
            vim.keymap.set(
                'n',
                '<leader>ca',
                '<cmd>Lspsaga code_action<CR>',
                { silent = true, desc = 'LspSaga code action' }
            )
            vim.keymap.set(
                'n',
                '<leader>gd',
                '<cmd>Lspsaga peek_definition<CR>',
                { silent = true, desc = 'LspSaga peek defn' }
            )
        end,
    },
    {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup({
                notification = {
                    window = {
                        normal_hl = 'Comment',
                        winblend = 0,
                    },
                },
                integration = {
                    ['nvim-tree'] = {
                        enable = false, -- don't need since nvim-tree is kept on left
                    },
                },
            })
        end,
    },
}
