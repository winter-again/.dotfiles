local M = {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            -- NOTE: must set up these plugins in specific order:
            -- 1) mason.nvim
            -- 2) mason-lspconfig.nvim
            -- 3) mason-tool-installer.nvim
            -- 4) lspconfig server setup -> I opt to use something from mason-lspconfig instead of normal lspconfig

            require("mason").setup({
                ui = {
                    -- border = 'solid',
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- "astro",
                    "bashls",
                    -- "clangd",
                    "cssls",
                    -- "css_variables",
                    "gopls",
                    "html",
                    "jsonls",
                    "lua_ls",
                    "marksman",
                    "pyright",
                    "ruff", -- newer LS than ruff_lsp
                    "rust_analyzer",
                    -- "tailwindcss",
                    "taplo",
                    "ts_ls",
                    "yamlls",
                },
                automatic_installation = false,
            })
            require("mason-tool-installer").setup({
                auto_update = true,
                debounce_hours = 24,
                ensure_installed = {
                    -- "black",
                    -- "isort",
                    -- "prettierd",
                    -- "sqlfluff",
                    "selene",
                    "stylua",
                    -- "goimports",
                },
            })
            local map = require("winteragain.globals").map
            -- keymaps defined on attach
            local function lsp_attach(client, bufnr)
                local opts = { silent = true, buffer = bufnr }
                -- default in v0.10
                map("n", "K", vim.lsp.buf.hover, opts, "Hover docs")
                map("n", "gs", function()
                    vim.diagnostic.open_float({ scope = "cursor" })
                end, opts, "Get cursor diagnostics")
                map("n", "gl", function()
                    vim.diagnostic.open_float({ scope = "line" })
                end, opts, "Get line diagnostics")

                if client.server_capabilities.documentHighlightProvider then
                    map("n", "gc", function()
                        if vim.g.doc_highlight then
                            vim.lsp.buf.clear_references()
                            vim.g.doc_highlight = false
                        else
                            vim.lsp.buf.document_highlight()
                            vim.g.doc_highlight = true
                        end
                    end, opts, "Highlight symbol under cursor")
                    -- local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
                    -- vim.api.nvim_create_autocmd("CursorMoved", {
                    --     group = group,
                    --     buffer = bufnr,
                    --     -- once = true,
                    --     callback = function()
                    --         vim.lsp.buf.clear_references()
                    --     end,
                    -- })
                end

                local ok_telescope, builtin = pcall(require, "telescope.builtin")
                local ok_fzf_lua, fzf_lua = pcall(require, "fzf-lua")
                if ok_telescope then
                    -- print("Using telescope for LSP keymaps")
                    map("n", "gd", builtin.lsp_definitions, opts, "LSP definitions")
                    map("n", "gr", builtin.lsp_references, opts, "LSP references")
                    map("n", "gI", builtin.lsp_implementations, opts, "LSP implementations")
                    map("n", "<leader>D", builtin.lsp_type_definitions, opts, "LSP type defns.")
                    map("n", "<leader>ds", builtin.lsp_document_symbols, opts, "LSP doc. symbols")
                    map("n", "<leader>ws", builtin.lsp_workspace_symbols, opts, "LSP workspace symbols")
                elseif ok_fzf_lua then
                    -- print("Using fzf-lua for LSP keymaps")
                    map("n", "gd", function()
                        fzf_lua.lsp_definitions({ jump1 = true })
                    end, opts, "LSP definitions")
                    map("n", "gr", fzf_lua.lsp_references, opts, "LSP references")
                    map("n", "gI", fzf_lua.lsp_implementations, opts, "LSP implementations")
                    map("n", "<leader>D", fzf_lua.lsp_typedefs, opts, "LSP type defns.")
                    map("n", "<leader>ds", fzf_lua.lsp_document_symbols, opts, "LSP doc. symbols")
                    map("n", "<leader>ws", fzf_lua.lsp_live_workspace_symbols, opts, "Workspace symbols")
                else
                    print("Neither telescope.nvim nor fzf-lua installed...")
                end

                map("n", "gD", vim.lsp.buf.declaration, opts, "Go to declaration")
                map("n", "<leader>ca", vim.lsp.buf.code_action, opts, "Code actions")
                -- map("n", "<leader>rn", vim.lsp.buf.rename, opts, "LSP default rename")
                -- map("n", "<leader>rn", ":IncRename ", opts, "LSP incremental rename")
                map("n", "<leader>rn", function()
                    return ":IncRename " .. vim.fn.expand("<cword>")
                end, { expr = true, silent = true }, "LSP incremental rename")

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map("n", "<leader>ih", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                    end, opts, "Toggle inlay hints")
                end
            end

            -- (4) see docs: https://github.com/williamboman/mason-lspconfig.nvim/blob/09be3766669bfbabbe2863c624749d8da392c916/doc/mason-lspconfig.txt#L157

            -- override capabilities sent to server so nvim-cmp can provide its own additionally supported candidates
            -- NOTE: snippetSupport = false by default
            local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
            -- from kickstart.nvim
            -- also see: https://github.com/hrsh7th/cmp-nvim-lsp/issues/38#issuecomment-1815265121
            -- NOTE: snippetSupport = true in require('cmp_nvim_lsp').default_capabilities() so it's forced to true
            lsp_capabilities =
                vim.tbl_deep_extend("force", lsp_capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- see here for configs:
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            -- handlers should be a table where keys are lspconfig server name and values are setup function
            -- pass default handler as first entry w/o key
            local handlers = {
                -- default handler called for each installed server
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = lsp_capabilities,
                        on_attach = lsp_attach,
                    })
                end,
                ["marksman"] = function()
                    local cwd = vim.uv.cwd()
                    if cwd == vim.fs.normalize("~/Documents/notebook") then
                        require("lspconfig")["marksman"].setup({
                            capabilities = lsp_capabilities,
                            on_attach = function(client, bufnr)
                                -- disable completion
                                client.server_capabilities.completionProvider = nil
                                lsp_attach(client, bufnr)
                            end,
                        })
                    else
                        require("lspconfig")["marksman"].setup({
                            capabilities = lsp_capabilities,
                            on_attach = lsp_attach,
                        })
                    end
                end,
                ["rust_analyzer"] = function()
                    require("lspconfig")["rust_analyzer"].setup({
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
                end,
                ["gopls"] = function()
                    require("lspconfig")["gopls"].setup({
                        capabilities = lsp_capabilities,
                        on_attach = lsp_attach,
                        settings = {
                            gopls = {
                                semanticTokens = false,
                            },
                        },
                    })
                end,
                ["lua_ls"] = function()
                    require("lspconfig")["lua_ls"].setup({
                        capabilities = lsp_capabilities,
                        on_attach = lsp_attach,
                        on_init = function(client)
                            if client.workspace_folders then
                                local path = client.workspace_folders[1].name
                                if
                                    vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")
                                then
                                    return
                                end
                            end

                            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                                runtime = {
                                    version = "LuaJIT", -- LuaJIT in case of nvim
                                },
                                -- seems like don't need
                                -- diagnostics = {
                                --     globals = { "vim" },
                                -- },
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
                                },
                            })
                        end,
                        settings = {
                            Lua = {},
                        },
                    })
                end,
                -- override default handler per server
                -- ['eslint'] = function()
                --     require('lspconfig')['eslint'].setup({
                --         capabilities = lsp_capabilities,
                --         -- this should only start eslint if the given config files are found
                --         root_dir = require('lspconfig').util.root_pattern('.eslintrc.js', 'eslint.config.js'),
                --         -- on_attach = on_attach,
                --     })
                -- end,
                ["tailwindcss"] = function()
                    require("lspconfig")["tailwindcss"].setup({
                        capabilities = lsp_capabilities,
                        -- only run LSP if tailwind config files present
                        root_dir = function(fname)
                            local root_pattern = require("lspconfig").util.root_pattern(
                                "tailwind.config.cjs",
                                "tailwind.config.js",
                                "tailwind.config.mjs",
                                "postcss.config.js"
                            )
                            return root_pattern(fname)
                        end,
                    })
                end,
                ["taplo"] = function()
                    require("lspconfig")["taplo"].setup({
                        capabilities = lsp_capabilities,
                        on_attach = function(client, bufnr)
                            -- disable autoformatting
                            if client.name == "taplo" then
                                client.server_capabilities.documentFormattingProvider = false
                            end
                            lsp_attach(client, bufnr)
                        end,
                    })
                end,
                ["clangd"] = function()
                    require("lspconfig")["clangd"].setup({
                        capabilities = lsp_capabilities,
                        on_attach = function(client, bufnr)
                            -- disable autoformatting
                            if client.name == "clangd" then
                                client.server_capabilities.documentFormattingProvider = false
                            end
                            lsp_attach(client, bufnr)
                        end,
                    })
                end,
                ["pyright"] = function()
                    require("lspconfig")["pyright"].setup({
                        on_attach = lsp_attach,
                        root_dir = require("lspconfig").util.root_pattern(".venv"),
                        -- remove capabilities that ruff can provide
                        -- https://github.com/astral-sh/ruff-lsp/issues/384
                        -- https://www.reddit.com/r/neovim/comments/11k5but/comment/jbjwwtf/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
                        settings = {
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
                end,
                ["ruff"] = function()
                    local group = vim.api.nvim_create_augroup("RuffWithPyright", { clear = true })
                    require("lspconfig")["ruff"].setup({
                        -- organize imports autocmd
                        on_attach = function(client, bufnr)
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                group = group,
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.code_action({
                                        ---@diagnostic disable: missing-fields
                                        context = { only = { "source.organizeImports" } },
                                        apply = true,
                                    })
                                    vim.wait(100)
                                end,
                            })
                            lsp_attach(client, bufnr)
                        end,
                    })
                    -- disable Ruff's hover to use Pyright instead; can't put this in on_attach
                    vim.api.nvim_create_autocmd("LspAttach", {
                        group = group,
                        callback = function(args)
                            local client = vim.lsp.get_client_by_id(args.data.client_id)
                            if client == nil then
                                return
                            end
                            if client.name == "ruff" then
                                client.server_capabilities.hoverProvider = false
                            end
                        end,
                        desc = "LSP: disable Ruff hover capability",
                    })
                end,
            }
            require("mason-lspconfig").setup_handlers(handlers)

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
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            ---@diagnostic disable: missing-parameter
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
return {}
