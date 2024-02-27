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
                    -- 'ruff_lsp',
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
                    'flake8',
                    'isort',
                    'prettierd',
                    'sqlfluff',
                    'selene',
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
            Map('n', '[d', vim.diagnostic.goto_prev, { silent = true }, 'Go to previous diagnostic message')
            Map('n', ']d', vim.diagnostic.goto_next, { silent = true }, 'Go to next diagnostic message')
            -- keymaps defined on attach
            local function on_attach(_, bufnr)
                local opts = { silent = true, buffer = bufnr }
                Map('n', 'K', vim.lsp.buf.hover, opts, 'Hover docs')
                Map('n', 'gs', function()
                    vim.diagnostic.open_float({ scope = 'cursor' })
                end, opts, 'Get cursor diagnostics')
                Map('n', 'gl', function()
                    vim.diagnostic.open_float({ scope = 'line' })
                end, opts, 'Get line diagnostics')
                Map('n', 'gd', require('telescope.builtin').lsp_definitions, opts, 'Telescope LSP defns.')
                Map('n', 'gD', vim.lsp.buf.declaration, opts, 'Go to declaration')
                Map('n', 'gr', require('telescope.builtin').lsp_references, opts, 'Telescope LSP refs.')
                Map('n', 'gI', require('telescope.builtin').lsp_implementations, opts, 'Telescope find impls.')
                Map('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, opts, 'Telescope type defns.')
                Map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, opts, 'Telescope doc symbols')
                Map(
                    'n',
                    '<leader>ws',
                    require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    opts,
                    'Telescope workspace symbols'
                )
                Map('n', '<leader><leader>rn', vim.lsp.buf.rename, opts, 'LSP default rename') -- default rename w/o fancy pop-up from LspSaga
                Map(
                    'n',
                    '<leader>ws',
                    require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    opts,
                    'Telescope workspace symbols'
                )
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
            -- global floating window borders by replacing the orig. function
            -- see here: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
            local orig_util_open_float_prev = vim.lsp.util.open_floating_preview
            vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
                opts = opts or {}
                -- opts.border = 'rounded'
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
                    prefix = '󱓻',
                    format = diagn_format,
                },
                float = {
                    -- border = 'rounded',
                    prefix = '󰉹 ',
                    suffix = '', -- get rid of the code that is shown by default since format func handles it
                    format = diagn_format,
                },
                signs = true,
                underline = true,
                update_in_insert = true, -- update diagnostics while in Insert mode
                severity_sort = true,
            })
        end,
    },
    {
        'glepnir/lspsaga.nvim',
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
            Map('n', '<leader>gf', '<cmd>Lspsaga finder<CR>', { silent = true }, 'LspSaga finder')
            -- rename all references to symbol under cursor
            Map('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true }, 'LspSaga rename')
            -- code action
            Map('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true }, 'LspSaga code action')
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
            Map('n', '<leader><leader>fm', function()
                require('conform').format({ async = true, lsp_fallback = true })
            end, { silent = true }, 'Manually format buffer with conform.nvim')
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
                lua = { 'selene' },
                javascript = { 'eslint' },
                javascriptreact = { 'eslint' },
                typescript = { 'eslint' },
                typescriptreact = { 'eslint' },
                markdown = {}, -- disables default linting?
                -- python = { 'flake8' },
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
            Map('n', '<leader><leader>l', function()
                require('lint').try_lint()
            end, { silent = true }, 'Manually trigger nvim-lint')
        end,
    },
}
