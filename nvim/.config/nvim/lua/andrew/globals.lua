-- global functions/settings
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

-- send config override signal to current wezterm
-- from folke's zen-mode plugin
Wezterm = function()
    local stdout = vim.loop.new_tty(1, false)
    -- stdout:write(('\x1b]1337;SetUserVar=%s=%s\b'):format('BG_IMG', vim.fn.system({ 'base64' }, 'foo')))
    stdout:write(('\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\007\x1b\\'):format('BG_IMG', vim.fn.system({ 'base64' }, 'bg_1')))
    -- stdout:write(('\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\'):format('BG_IMG', vim.fn.system({ 'base64' }, 'foo')))
end
vim.keymap.set('n', '<leader><leader>w', ':lua Wezterm()<CR>')
