-- helpful for displaying Lua table contents (from TJ)
P = function(v)
    print(vim.print(v))
    return v
end

-- reload packages during dev (from TJ)
local require = require
local ok, plenary_reload = pcall(require, 'plenary.reload')
local reloader = require
if ok then
    reloader = plenary_reload.reload_module
end

RELOAD = function(...)
    local ok, plenary_reload = pcall(require, 'plenary.reload')
    if ok then
        reloader = plenary_reload.reload_module
    end

    return reloader(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end

-- save and execute lua file for quick iterating
Save_exec = function()
    vim.cmd('silent! write')
    vim.cmd('luafile %')
end

-- transparency
Transp = function()
    local highlights = {
        'Normal',
        'NormalNC', -- unfocused windows
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
