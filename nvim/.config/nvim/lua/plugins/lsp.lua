return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            {
                "smjonas/inc-rename.nvim",
                opts = {},
            },
        },
        config = function()
            local methods = vim.lsp.protocol.Methods

            local map = require("winteragain.globals").map
            local au_group = vim.api.nvim_create_augroup("winter.again", { clear = false })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = au_group,
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local bufnr = event.buf
                    local opts = { silent = true, buffer = bufnr }

                    -- NOTE: some of these are now default keymaps
                    if client and client:supports_method(methods.textDocument_hover) then
                        map("n", "K", vim.lsp.buf.hover, opts, "Hover docs")
                    end
                    if client and client:supports_method(methods.textDocument_declaration) then
                        map("n", "gD", vim.lsp.buf.declaration, opts, "Go to declaration")
                    end
                    if client and client:supports_method(methods.textDocument_inlayHint) then
                        map("n", "<leader>ih", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                        end, opts, "Toggle inlay hints")
                    end
                    if client and client:supports_method(methods.textDocument_rename) then
                        map("n", "grn", function()
                            return ":IncRename " .. vim.fn.expand("<cword>")
                        end, { expr = true, silent = true }, "LSP incremental rename")
                        -- map("n", "grn", vim.lsp.buf.rename, opts, "LSP default rename")
                    end
                    if client and client:supports_method(methods.textDocument_codeAction) then
                        map({ "n", "v" }, "gca", vim.lsp.buf.code_action, opts, "Code actions")
                    end

                    map("n", "gs", function()
                        vim.diagnostic.open_float({ scope = "cursor" })
                    end, opts, "Get cursor diagnostics")
                    map("n", "gl", function()
                        vim.diagnostic.open_float({ scope = "line" })
                    end, opts, "Get line diagnostics")

                    if client and client:supports_method(methods.textDocument_documentHighlight) then
                        map("n", "gc", function()
                            if vim.g.doc_highlight then
                                vim.lsp.buf.clear_references()
                                vim.g.doc_highlight = false
                            else
                                vim.lsp.buf.document_highlight()
                                vim.g.doc_highlight = true
                            end
                        end, opts, "Highlight symbol under cursor")
                    end

                    local ok_telescope, builtin = pcall(require, "telescope.builtin")
                    local ok_fzf_lua, fzf_lua = pcall(require, "fzf-lua")
                    if ok_telescope then
                        map("n", "gd", builtin.lsp_definitions, opts, "LSP definitions")
                        map("n", "gr", builtin.lsp_references, opts, "LSP references")
                        map("n", "gI", builtin.lsp_implementations, opts, "LSP implementations")
                        map("n", "<leader>D", builtin.lsp_type_definitions, opts, "LSP type defns.")
                        map("n", "<leader>ds", builtin.lsp_document_symbols, opts, "LSP doc. symbols")
                        map("n", "<leader>ws", builtin.lsp_workspace_symbols, opts, "LSP workspace symbols")
                    elseif ok_fzf_lua then
                        if client and client:supports_method(methods.textDocument_definition) then
                            map("n", "gd", function()
                                fzf_lua.lsp_definitions({ jump1 = true })
                            end, opts, "LSP definition")
                            map("n", "gp", function()
                                fzf_lua.lsp_definitions({ jump1 = false })
                            end, opts, "LSP peek definition")
                            map("n", "gr", fzf_lua.lsp_references, opts, "LSP references")

                            map("n", "<leader>D", fzf_lua.lsp_typedefs, opts, "LSP type defns.")
                        end
                        if client and client:supports_method(methods.textDocument_implementation) then
                            map("n", "gI", fzf_lua.lsp_implementations, opts, "LSP implementations")
                        end
                        if client and client:supports_method(methods.textDocument_documentSymbol) then
                            map("n", "<leader>ds", fzf_lua.lsp_document_symbols, opts, "LSP doc. symbols")
                        end
                        if client and client:supports_method(methods.workspace_symbol) then
                            map("n", "<leader>ws", fzf_lua.lsp_live_workspace_symbols, opts, "Workspace symbols")
                        end
                    else
                        print("Neither telescope.nvim nor fzf-lua installed...")
                    end
                end,
            })

            -- NOTE: https://neovim.io/doc/user/diagnostic.html
            -- custom signs for diagnostics; trouble.nvim can use too
            local diagnostic_icons = {
                Error = "",
                Warn = "",
                Info = "",
                Hint = "",
            }
            for severity, icon in pairs(diagnostic_icons) do
                local hl = "DiagnosticSign" .. severity
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            local function diag_format(diagnostic)
                return string.format(
                    "%s [%s]  %s",
                    diagnostic.message or "",
                    diagnostic.source or "",
                    diagnostic.code or diagnostic.user_data or ""
                )
            end

            vim.diagnostic.config({
                virtual_text = {
                    spacing = 4,
                    prefix = "󰝤",
                    -- prefix = "󱓻",
                    format = diag_format,
                },
                float = {
                    prefix = function(diagnostic, i, total)
                        local severity_upper = vim.diagnostic.severity[diagnostic.severity]
                        local severity = severity_upper:sub(1, 1) .. severity_upper:sub(2):lower()
                        local prefix = string.format(" %s ", diagnostic_icons[severity])

                        -- return prefix and optionally highlight group to use
                        return prefix, "Diagnostic" .. severity
                    end,
                    suffix = "", -- get rid of the code that is shown by default since format func handles it
                    format = diag_format,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
                        [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
                        [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
                        [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
                    },
                    linehl = {
                        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                    },
                    numhl = {
                        [vim.diagnostic.severity.WARN] = "WarningMsg",
                    },
                },
                underline = true,
                update_in_insert = false, -- update diagnostics while in Insert mode
                severity_sort = true,
            })

            -- NOTE: settings specified here extend the default settings provided by nvim-lspconfig
            local servers = {
                ["lua_ls"] = {
                    on_init = function(client)
                        if client.workspace_folders then
                            local path = client.workspace_folders[1].name
                            if
                                path ~= vim.fn.stdpath("config")
                                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                            then
                                return
                            end
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = "LuaJIT",
                            },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = false,
                                -- NOTE: library should now be handled by lazydev
                                -- library = {
                                --     vim.env.VIMRUNTIME,
                                --     -- Depending on the usage, you might want to add additional paths here.
                                --     -- "${3rd}/luv/library"
                                --     -- "${3rd}/busted/library",
                                -- },
                            },
                            telemetry = {
                                enable = false,
                            },
                            -- diagnostics = {
                            --     disable = { "missing-fields" },
                            -- },
                            hint = {
                                enable = true,
                                arrayIndex = "Disable",
                                setType = true,
                            },
                        })
                    end,
                    settings = {
                        Lua = {},
                    },
                },
                ["basedpyright"] = {
                    settings = {
                        basedpyright = {
                            -- see settings: https://github.com/microsoft/pyright/blob/54f7da25f9c2b6253803602048b04fe0ccb13430/docs/settings.md
                            disableOrganizeImports = true, -- use Ruff instead
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                useLibraryCodeForTypes = true,
                                autoImportCompletions = false,
                                diagnosticSeverityOverrides = {
                                    reportUndefinedVariable = "none",
                                },
                            },
                        },
                    },
                },
                ["ruff"] = {
                    on_attach = function(client, bufnr)
                        -- disable Ruff's hover to use Pyright instead
                        client.server_capabilities.hoverProvider = false
                    end,
                    -- NOTE: server settings here
                    -- init_options = {
                    --     settings = {},
                    -- },
                },
                ["gopls"] = {
                    settings = {
                        gopls = {
                            semanticTokens = true,
                            analyses = {
                                -- see https://github.com/golang/tools/blob/3e7f74d009150bf5e66483f3759d8c59f50e873d/gopls/doc/analyzers.md
                                -- these might all be on by default?
                                nilness = true, -- reports nil pointer issues
                                shadow = true, -- shadowed vars
                                unusedparams = true, -- checks for unused params of funcs
                                unusedwrite = true, -- instances of writes to struct fields or arrays that are never read
                                useany = true,
                            },
                            hints = {
                                -- for inlay hints
                                -- see https://go.googlesource.com/tools/+/4d205d81b5a0f7cb051584b8964b7a0fd6d502c2/gopls/doc/inlayHints.md
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                        },
                    },
                },
                ["marksman"] = {
                    on_attach = function(client, bufnr)
                        if vim.uv.cwd() == vim.fs.normalize("~/Documents/notebook") then
                            -- disable some capabilities in notes dir to use zk/obsidian instead
                            client.server_capabilities.completionProvider = nil
                            client.server_capabilities.hoverProvider = false
                        end
                    end,
                },
                ["rust_analyzer"] = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                        },
                    },
                },
                ["astro"] = {},
                ["clangd"] = {},
                ["html"] = {
                    init_options = {
                        configurationSection = { "html", "css", "javascript" },
                        embeddedLanguages = {
                            css = true,
                            javascript = true,
                        },
                        provideFormatter = false, -- using prettier instead
                    },
                },
                ["cssls"] = {},
                ["ts_ls"] = {},
                ["bashls"] = {},
                ["jsonls"] = {
                    -- on_attach = function(client, bufnr)
                    --     -- NOTE: jsonls includes formatting capabilities by default
                    --     client.server_capabilities.documentFormattingProvider = false
                    -- end,
                },
                ["taplo"] = {
                    on_attach = function(client, bufnr)
                        -- NOTE: taplo includes formatting capabilities by default
                        -- turn off for pyproject.toml files
                        local file = vim.api.nvim_buf_get_name(bufnr)
                        if file:match("pyproject.toml$") then
                            client.server_capabilities.documentFormattingProvider = false
                        end
                    end,
                },
                ["tinymist"] = {
                    settings = {
                        formatterMode = "typstyle",
                        formatterIndentSize = 4,
                        lint = {
                            enabled = true,
                            when = "onSave",
                        },
                    },
                },
                ["yamlls"] = {
                    on_attach = function(client, bufnr)
                        -- NOTE: yamlls includes formatting capabilities; disable it, though
                        -- it doesn't seem to work anyway?
                        client.server_capabilities.documentFormattingProvider = false
                    end,
                },
            }

            for server, config in pairs(servers) do
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({
                notification = {
                    window = {
                        normal_hl = "Normal",
                        winblend = 0,
                    },
                },
            })
        end,
    },
}
