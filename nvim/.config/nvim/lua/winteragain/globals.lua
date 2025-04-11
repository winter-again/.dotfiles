local M = {}

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
    vim.cmd("Lazy reload " .. plugin)
end

---Save and execute Lua file for quick iterating
function Save_exec()
    local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    if ft == "lua" then
        vim.cmd("silent! write")
        vim.cmd("luafile %")
    end
end

--Save and execute cursor line for Lua file
function Save_exec_line()
    local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    if ft == "lua" then
        vim.cmd("silent! write")
        local cursor_line = vim.fn.getline(".")
        vim.cmd("lua " .. cursor_line)
    end
end

---Set custom transparency settings
function M.transparent()
    local highlights = {
        "Normal",
        "NormalNC", -- unfocused windows
        -- 'NormalFloat', -- affects docs pop-up
        "Float",
        "FloatTitle",
        "FloatBorder",
        "SignColumn",
        "FoldColumn",
        "TelescopeBorder",
        -- 'Pmenu', -- this is only reasonable if we have a border set
    }
    for _, hl in pairs(highlights) do
        local curr_hl = vim.api.nvim_get_hl(0, { name = hl })
        local new_hl = vim.tbl_extend("force", curr_hl, { bg = "none" })
        vim.api.nvim_set_hl(0, hl, new_hl)
    end
end
vim.api.nvim_create_user_command("Transparent", function()
    M.transparent()
end, { desc = "Make nvim transparent" })

function M.Toggle_light_dark()
    local curr_set = vim.api.nvim_get_option_value("background", { scope = "global" })
    if curr_set == "dark" then
        vim.opt.background = "light"
    else
        vim.opt.background = "dark"
    end
end
vim.api.nvim_create_user_command("ToggleLightDark", function()
    M.Toggle_light_dark()
end, { desc = "Toggle light/dark mode" })

---Convenience function for setting a highlight group in current buf
---@param group string
---@param hl table
function M.Hl(group, hl)
    vim.api.nvim_set_hl(0, group, hl)
end

---Custom function for setting winbar info
---@return string
function Winbar()
    local function word_count()
        return string.format("(%s W)", vim.fn.wordcount().words)
    end

    -- local path = vim.api.nvim_buf_get_name(0):gsub(os.getenv('HOME'), '~')
    -- %f = path, as typed ore relative to current dir
    -- %n = buf number
    -- %r = the readonly flag "[RO]"
    -- %m = modified flag "[+]"
    local base = vim.api.nvim_eval_statusline("%f - [%n]", {}).str
    local mod = vim.api.nvim_eval_statusline("%m", {}).str
    local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local read_only = vim.api.nvim_get_option_value("readonly", { buf = 0 })

    local winbar = string.format("%s %s", base, mod)
    if ft == "markdown" then
        winbar = string.format("%s %s %s", base, word_count(), mod)
    end
    if read_only == true then
        winbar = base .. " 󰌾"
    end

    local exclude = {
        "NvimTree",
        "alpha",
    }
    if vim.list_contains(exclude, ft) then
        return ""
    end

    return winbar
end

--- Keymap helper function
---@param mode string | string[]
---@param lhs string
---@param rhs string | function
---@param opts? vim.keymap.set.Opts
---@param desc string
function M.map(mode, lhs, rhs, opts, desc)
    opts = opts or {}
    opts.desc = desc

    vim.keymap.set(mode, lhs, rhs, opts)
end

return M
