-- helpful for displaying Lua table contents (from TJ)
function P(v)
    print(vim.print(v))
    return v
end

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
vim.api.nvim_create_user_command('Transparent', function()
    Transp()
end, { desc = 'Make nvim transparent' })

function Toggle_light_dark()
    local curr_set = vim.api.nvim_get_option('background')
    if curr_set == 'dark' then
        vim.opt.background = 'light'
    else
        vim.opt.background = 'dark'
    end
end
vim.api.nvim_create_user_command('ToggleLightDark', function()
    Toggle_light_dark()
end, { desc = 'Toggle light/dark mode' })

function Hl(group, hl)
    vim.api.nvim_set_hl(0, group, hl)
end

function Map(mode, lhs, rhs, opts, desc)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end

function Winbar()
    -- https://github.com/chrisgrieser/.config/blob/8af1841ba24f7c81c513e12f853b52f530ef5b37/nvim/lua/plugins/lualine.lua
    -- local function Sel_count()
    --     local is_visual = vim.fn.mode():find('[Vv]')
    --     if not is_visual then
    --         return ''
    --     end
    --     local starts = vim.fn.line('v')
    --     local ends = vim.fn.line('.')
    --     local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
    --     return ' ' .. tostring(lines) .. 'L ' .. tostring(vim.fn.wordcount().visual_chars) .. 'C'
    -- end

    local function word_count()
        return '- [' .. vim.fn.wordcount().words .. ' W]'
    end

    -- %f = path, as typed ore relative to current dir
    -- %n = buf number
    local file_path_bufnr = vim.api.nvim_eval_statusline('%f - [%n]', {}).str
    -- %m = modified flag, text is '[+]' and '[-]' if modifiable is off
    local mod = vim.api.nvim_eval_statusline('%m', {}).str
    local buftype = vim.bo.filetype
    local exclude = {
        'NvimTree',
        'alpha',
    }
    if vim.tbl_contains(exclude, buftype) then
        return ''
    end
    if buftype == 'markdown' then
        return string.format('%s %s %s', file_path_bufnr, word_count(), mod)
    end
    return string.format('%s %s', file_path_bufnr, mod)
end
