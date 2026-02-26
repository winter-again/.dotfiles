return {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    config = function()
        require('zen-mode').setup({
            window = {
                options = {
                    foldcolumn = '0', -- disable fold column
                },
            },
            plugins = {
                wezterm = {
                    -- to enable, need to add some stuff to Wezterm config too
                    enabled = true,
                },
            },
        })
    end,
}
