return {
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

        Map({ 'i', 's' }, '<C-n>', function()
            require('luasnip').jump(1)
        end, { silent = true }, 'Jump to next snippet node')
        Map({ 'i', 's' }, '<C-p>', function()
            require('luasnip').jump(-1)
        end, { silent = true }, 'Jump to previous snippet node')
    end,
}
