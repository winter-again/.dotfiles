-- helpful for displaying Lua table contents (from TJ)
function P(v)
    print(vim.print(v))
    return v
end

-- reload packages during dev (from TJ)
-- local require = require
-- local ok, plenary_reload = pcall(require, 'plenary.reload')
-- local reloader = require
-- if ok then
--     reloader = plenary_reload.reload_module
-- end
--
-- RELOAD = function(...)
--     local ok, plenary_reload = pcall(require, 'plenary.reload')
--     if ok then
--         reloader = plenary_reload.reload_module
--     end
--
--     return reloader(...)
-- end
--
-- R = function(name)
--     RELOAD(name)
--     return require(name)
-- end

function R(plugin)
    vim.cmd('Lazy reload ' .. plugin)
end

-- save and execute lua file for quick iterating
function Save_exec()
    vim.cmd('silent! write')
    vim.cmd('luafile %')
end

function Transp()
    local highlights = {
        'Normal',
        'NormalNC', -- unfocused windows
        -- 'NormalFloat', -- affects docs pop-up
        'Float',
        'FloatTitle',
        'FloatBorder',
        'SignColumn',
        'FoldColumn',
        'TelescopeBorder',
    }
    for _, hl in pairs(highlights) do
        local curr_hl = vim.api.nvim_get_hl(0, { name = hl })
        local new_hl = vim.tbl_extend('force', curr_hl, { bg = 'none' })
        vim.api.nvim_set_hl(0, hl, new_hl)
    end
end

function Toggle_light_dark()
    local curr_set = vim.api.nvim_get_option('background')
    if curr_set == 'dark' then
        vim.opt.background = 'light'
    else
        vim.opt.background = 'dark'
    end
end

function Hl(group, hl)
    vim.api.nvim_set_hl(0, group, hl)
end
