-- global functions/settings
-- helpful for displaying Lua table contents
P = function(v)
    print(vim.print(v))
    return v
end

-- transparency
Transp = function()
    local highlights = {
        'Normal',
        -- 'NormalNC', -- seems to work w/o this
        -- 'NormalFloat', -- affects docs pop-up
        -- 'Float',
        'FloatTitle',
        'SignColumn',
        'FoldColumn',
    }
    for _, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl, { bg = 'none' })
    end
end
