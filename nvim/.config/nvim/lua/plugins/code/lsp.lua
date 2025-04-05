return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            --- Default on_attach function for common settings/keymaps
            ---@param client vim.lsp.Client
            ---@param bufnr integer
            local function lsp_attach(client, bufnr)
                --- Keymap helper function
                ---@param mode string | string[]
                ---@param lhs string
                ---@param rhs string | function
                ---@param opts? vim.keymap.set.Opts
                ---@param desc string
                local function map(mode, lhs, rhs, opts, desc)
                    opts = opts or {}
                    opts.desc = desc
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                local opts = { silent = true, buffer = bufnr }
                local methods = vim.lsp.protocol.Methods

                -- some of these became default keymaps
                if client:supports_method(methods.textDocument_hover) then
                    map("n", "K", vim.lsp.buf.hover, opts, "Hover docs")
                end
                if client:supports_method(methods.textDocument_declaration) then
                    map("n", "gD", vim.lsp.buf.declaration, opts, "Go to declaration")
                end
                if client:supports_method(methods.textDocument_inlayHint) then
                    map("n", "<leader>ih", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                    end, opts, "Toggle inlay hints")
                end
                if client:supports_method(methods.textDocument_rename) then
                    map("n", "grn", function()
                        return ":IncRename " .. vim.fn.expand("<cword>")
                    end, { expr = true, silent = true }, "LSP incremental rename")
                    -- map("n", "grn", vim.lsp.buf.rename, opts, "LSP default rename")
                end
                if client:supports_method(methods.textDocument_codeAction) then
                    map({ "n", "v" }, "gca", vim.lsp.buf.code_action, opts, "Code actions")
                end

                -- NOTE: replaces cmp-nvim-lsp-signature-help but req keymap trigger
                if client:supports_method(methods.textDocument_signatureHelp) then
                    ---@diagnostic disable-next-line missing-parameter
                    map({ "i", "s" }, "<C-k>", function()
                        local cmp = require("cmp")
                        if cmp.visible() then
                            cmp.close()
                        end

                        vim.lsp.buf.signature_help()
                    end)
                end

                map("n", "gs", function()
                    vim.diagnostic.open_float({ scope = "cursor" })
                end, opts, "Get cursor diagnostics")
                map("n", "gl", function()
                    vim.diagnostic.open_float({ scope = "line" })
                end, opts, "Get line diagnostics")

                if client:supports_method(methods.textDocument_documentHighlight) then
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
                    if client:supports_method(methods.textDocument_definition) then
                        map("n", "gd", function()
                            fzf_lua.lsp_definitions({ jump1 = true })
                        end, opts, "LSP definition")
                        map("n", "gp", function()
                            fzf_lua.lsp_definitions({ jump1 = false })
                        end, opts, "LSP peek definition")
                        map("n", "gr", fzf_lua.lsp_references, opts, "LSP references")

                        map("n", "<leader>D", fzf_lua.lsp_typedefs, opts, "LSP type defns.")
                    end
                    if client:supports_method(methods.textDocument_implementation) then
                        map("n", "gI", fzf_lua.lsp_implementations, opts, "LSP implementations")
                    end
                    if client:supports_method(methods.textDocument_documentSymbol) then
                        map("n", "<leader>ds", fzf_lua.lsp_document_symbols, opts, "LSP doc. symbols")
                    end
                    if client:supports_method(methods.workspace_symbol) then
                        map("n", "<leader>ws", fzf_lua.lsp_live_workspace_symbols, opts, "Workspace symbols")
                    end
                else
                    print("Neither telescope.nvim nor fzf-lua installed...")
                end
            end

            local lspconfig = require("lspconfig")
            -- from kickstart.nvim
            -- override capabilities sent to server so nvim-cmp can provide its own additionally supported candidates
            -- also see: https://github.com/hrsh7th/cmp-nvim-lsp/issues/38#issuecomment-1815265121
            -- NOTE: snippetSupport = false by default but true in require('cmp_nvim_lsp').default_capabilities() so it's forced to true
            local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
            lsp_capabilities =
                vim.tbl_deep_extend("force", lsp_capabilities, require("cmp_nvim_lsp").default_capabilities())

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
                Error = "",
                Warn = "",
                Info = "",
                Hint = "",
            }
            for type, icon in pairs(sign_icons) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            local function diagn_format(diagnostic)
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
                    prefix = "󱓻",
                    format = diagn_format,
                },
                float = {
                    -- border = 'rounded',
                    prefix = "󰉹 ",
                    suffix = "", -- get rid of the code that is shown by default since format func handles it
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

            lspconfig["lua_ls"].setup({
                capabilities = lsp_capabilities,
                on_attach = lsp_attach,
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
                            version = "LuaJIT", -- LuaJIT in case of nvim
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        -- tell server about nvim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                "${3rd}/luv/library", -- seems like I need this to see vim.uv
                                "$XDG_DATA_HOME/nvim/lazy/lazy.nvim/lua",
                                "$XDG_DATA_HOME/nvim/lazy/nvim-cmp/lua",
                            },
                        },
                        telemetry = {
                            enable = false,
                        },
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
            })

            lspconfig["pyright"].setup({
                capabilities = lsp_capabilities,
                on_attach = lsp_attach,
                -- TODO: why this?
                -- root_dir = require("lspconfig").util.root_pattern(".venv"),
                -- remove capabilities that ruff can provide
                -- https://github.com/astral-sh/ruff-lsp/issues/384
                -- https://www.reddit.com/r/neovim/comments/11k5but/comment/jbjwwtf/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
                settings = {
                    -- see settings: https://github.com/microsoft/pyright/blob/54f7da25f9c2b6253803602048b04fe0ccb13430/docs/settings.md
                    pyright = {
                        disableOrganizeImports = true, -- use Ruff instead
                    },
                    python = {
                        analysis = {
                            -- ignore = { '*' }, -- use Ruff for linting; disables all pyright
                            -- alt: have to go one by one if preserving pyright type-checking
                            -- see: https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
                            -- note that some of the Pyright stuff are "hints" and can't be easily removed
                            diagnosticSeverityOverrides = {
                                reportUndefinedVariable = "none",
                            },
                        },
                    },
                },
            })

            lspconfig["ruff"].setup({
                on_attach = function(client, bufnr)
                    -- disable Ruff's hover to use Pyright instead; can't put this in on_attach
                    client.server_capabilities.hoverProvider = false

                    -- organize imports autocmd
                    local group = vim.api.nvim_create_augroup("RuffWithPyright", { clear = true })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = group,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.code_action({
                                context = { only = { "source.organizeImports" } },
                                apply = true,
                            })
                            vim.wait(100)
                        end,
                    })

                    lsp_attach(client, bufnr)
                end,
            })

            lspconfig["gopls"].setup({
                capabilities = lsp_capabilities,
                on_attach = function(client, bufnr)
                    -- see https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
                    local group = vim.api.nvim_create_augroup("GoImports", { clear = true })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = group,
                        buffer = bufnr,
                        callback = function()
                            local params = vim.lsp.util.make_range_params(0, "utf-8")
                            params.context = { only = { "source.organizeImports" } }
                            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                            -- machine and codebase, you may want longer. Add an additional
                            -- argument after params if you find that you have to write the file
                            -- twice for changes to be saved.
                            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                            for cid, res in pairs(result or {}) do
                                for _, r in pairs(res.result or {}) do
                                    if r.edit then
                                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                    end
                                end
                            end
                            vim.lsp.buf.format({ async = false })
                        end,
                    })

                    lsp_attach(client, bufnr)
                end,
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
            })

            local cwd = vim.uv.cwd()
            if cwd == vim.fs.normalize("~/Documents/notebook") then
                lspconfig["marksman"].setup({
                    capabilities = lsp_capabilities,
                    on_attach = function(client, bufnr)
                        -- disable completion
                        client.server_capabilities.completionProvider = nil
                        lsp_attach(client, bufnr)
                    end,
                })
            else
                lspconfig["marksman"].setup({
                    capabilities = lsp_capabilities,
                    on_attach = lsp_attach,
                })
            end

            lspconfig["rust_analyzer"].setup({
                capabilities = lsp_capabilities,
                on_attach = lsp_attach,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                    },
                },
            })

            lspconfig["html"].setup({
                capabilities = lsp_capabilities,
                on_attach = lsp_attach,
                init_options = {
                    configurationSection = { "html", "css", "javascript" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true,
                    },
                    provideFormatter = false, -- using prettier instead
                },
            })
            lspconfig["cssls"].setup({ capabilities = lsp_capabilities, on_attach = lsp_attach })
            lspconfig["ts_ls"].setup({ capabilities = lsp_capabilities, on_attach = lsp_attach })

            lspconfig["bashls"].setup({ capabilities = lsp_capabilities, on_attach = lsp_attach })

            lspconfig["jsonls"].setup({ capabilities = lsp_capabilities, on_attach = lsp_attach })
            lspconfig["taplo"].setup({ capabilities = lsp_capabilities, on_attach = lsp_attach })
            lspconfig["yamlls"].setup({ capabilities = lsp_capabilities, on_attach = lsp_attach })
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({
                notification = {
                    window = {
                        normal_hl = "Comment",
                        winblend = 0,
                    },
                },
                integration = {
                    ["nvim-tree"] = {
                        enable = false, -- don't need since nvim-tree is kept on left
                    },
                },
            })
        end,
    },
}
