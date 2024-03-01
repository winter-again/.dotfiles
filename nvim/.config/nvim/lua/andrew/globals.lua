---Pretty print Lua table and its id (from TJ)
---@param tbl table
---@return table
function P(tbl)
    print(vim.print(tbl))
    return tbl
end

---Make lazy.nvim reload given plugin
---@param plugin string
function R(plugin)
    vim.cmd('Lazy reload ' .. plugin)
end

---Save and execute lua file for quick iterating
function Save_exec()
    vim.cmd('silent! write')
    vim.cmd('luafile %')
end

---Set custom transparency settings
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

---Convenience function for setting a highlight group in current buf
---@param group string
---@param hl table
function Hl(group, hl)
    vim.api.nvim_set_hl(0, group, hl)
end

---Convenience function for setting keymap with a description
---@param mode string | table
---@param lhs string
---@param rhs string | function
---@param opts table
---@param desc string
function Map(mode, lhs, rhs, opts, desc)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end

---Custom function for setting winbar info
---@return string
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

    -- TODO: can prob clean up the logic here
    -- %f = path, as typed ore relative to current dir
    -- %n = buf number
    -- %R = the readonly flag "RO"
    local bufnr = vim.api.nvim_get_current_buf()
    local file_path_bufnr
    if vim.bo[bufnr].readonly then
        file_path_bufnr = vim.api.nvim_eval_statusline('%f - [%n] %R', {}).str
        file_path_bufnr = file_path_bufnr:gsub('RO', '󰌾')
    else
        file_path_bufnr = vim.api.nvim_eval_statusline('%f - [%n]', {}).str
    end

    -- %m = modified flag, text is '[+]' and '[-]' if modifiable is off
    local mod = vim.api.nvim_eval_statusline('%m', {}).str
    local buftype = vim.bo.filetype
    local exclude = {
        'NvimTree',
        'alpha',
    }
    if vim.list_contains(exclude, buftype) then
        return ''
    end
    if buftype == 'markdown' then
        return string.format('%s %s %s', file_path_bufnr, word_count(), mod)
    end
    return string.format('%s %s', file_path_bufnr, mod)
end
