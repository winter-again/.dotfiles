--- @diagnostic disable: missing-fields
return {
    'hrsh7th/nvim-cmp',
    version = false,
    lazy = false,
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        'saadparwaiz1/cmp_luasnip', -- snippet cmp integration
        'onsails/lspkind.nvim', -- completion menu icons
        {
            'L3MON4D3/LuaSnip',
            version = 'v2.*',
            build = (function()
                -- build step needed for optional regex support in snipppets
                if vim.fn.executable('make') == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
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
                vim.keymap.set({ 'i', 's' }, '<C-h>', function()
                    require('luasnip').jump(-1)
                end, { silent = true, desc = 'Jump to previous snippet node' })
                vim.keymap.set({ 'i', 's' }, '<C-l>', function()
                    require('luasnip').jump(1)
                end, { silent = true, desc = 'Jump to next snippet node' })
            end,
        },
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
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            experimental = {
                ghost_text = false,
            },
            formatting = {
                fields = { 'abbr', 'kind', 'menu' }, -- what fields show in completion item
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    menu = {
                        nvim_lsp = '[LSP]',
                        luasnip = '[snip]',
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
                -- ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-y>'] = cmp.config.disable,
                ['<C-e>'] = cmp.mapping.abort(),
                -- nav snippet expansion locs
                ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            }),
        })
        -- use buffer source for '/' and '?'
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' },
            },
        })
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'nvim_lsp_document_symbol' },
            }, {
                { name = 'buffer' },
            }),
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
    end,
}
