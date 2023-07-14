return {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    config = function()
        require('zen-mode').setup({
            window = {
                -- width = 150,
                options = {
                    foldcolumn = '0' -- disable fold column
                }
            },
            plugins = {
                wezterm = {
                    -- to enable, need to add some stuff to Wezterm config too
                    -- not sure if it's working properly?
                    -- enabled = true,
                    -- set an absolute font
                    -- font = 12
                }
            }
        })
    end
}
