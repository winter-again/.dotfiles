local icons = require("winter-again.icons")
local mini_icons = require("mini.icons")

---Highlight text as statusline segment
---@param text string
---@param hl string
---@return string
local function hl_segment(text, hl)
    -- format: %#HighlightGroup#
    -- %* resets to default hl
    return string.format("%%#%s#%s%%*", hl, text)
end

local M = {}

---@return string
function M.mode()
    local mode_map = {
        ["n"] = "NORMAL",
        ["no"] = "O-PENDING",
        ["nov"] = "O-PENDING",
        ["noV"] = "O-PENDING",
        ["no\22"] = "O-PENDING",
        ["niI"] = "NORMAL",
        ["niR"] = "NORMAL",
        ["niV"] = "NORMAL",
        ["nt"] = "NORMAL",
        ["ntT"] = "NORMAL",
        ["v"] = "VISUAL",
        ["vs"] = "VISUAL",
        ["V"] = "V-LINE",
        ["Vs"] = "V-LINE",
        ["\22"] = "V-BLOCK",
        ["\22s"] = "V-BLOCK",
        ["s"] = "SELECT",
        ["S"] = "S-LINE",
        ["\19"] = "S-BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["ix"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rc"] = "REPLACE",
        ["Rx"] = "REPLACE",
        ["Rv"] = "V-REPLACE",
        ["Rvc"] = "V-REPLACE",
        ["Rvx"] = "V-REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "EX",
        ["ce"] = "EX",
        ["r"] = "REPLACE",
        ["rm"] = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
    }
    local mode_label = mode_map[vim.api.nvim_get_mode().mode]
    local hl_suffix = "Other"
    if mode_label == "NORMAL" then
        hl_suffix = "Normal"
    elseif mode_label == "INSERT" or mode_label == "SELECT" then
        hl_suffix = "Insert"
    elseif mode_label:sub(1, 1) == "V" then
        hl_suffix = "Visual"
    elseif mode_label == "COMMAND" or mode_label == "TERMINAL" or mode_label == "EX" then
        hl_suffix = "Command"
    elseif mode_label:sub(3) == "PENDING" then
        hl_suffix = "Pending"
    end

    return hl_segment(string.format(" %s ", mode_label), string.format("StatuslineMode%s", hl_suffix))
end

---@return string
function M.git_status()
    local status = vim.b.gitsigns_status_dict
    if not status then
        return ""
    end

    local head = hl_segment(string.format(" %s %s ", icons.git.head, status.head), "StatuslineGitHead")
    local added = status.added and hl_segment(string.format(" %s %d", icons.git.added, status.added), "GitSignsAdd")
        or ""
    local changed = status.changed
            and hl_segment(string.format(" %s %d", icons.git.changed, status.changed), "GitSignsChange")
        or ""
    local deleted = status.removed
            and hl_segment(string.format(" %s %d", icons.git.deleted, status.removed), "GitSignsDelete")
        or ""

    return table.concat({
        head,
        added,
        changed,
        deleted,
    })
end

---@return string
function M.file()
    -- NOTE: modifiers:
    -- :p = full path; use "~/" for home dir
    -- :~ = reduce to be relative to home dir
    -- :. = reduce to be relative to current dir if possible
    local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:~:.")
    if file_name == "" then
        file_name = "[untitled]"
    end
    local file_type = vim.bo.filetype
    local icon, hl = mini_icons.get("filetype", file_type)
    local file_icon = hl_segment(icon, hl)

    local modified = vim.bo.modified
    local read_only = vim.api.nvim_get_option_value("readonly", { buf = 0 })

    return table.concat({
        " ",
        file_icon,
        " ",
        file_name,
        modified and " [+]" or "",
        read_only and " 󰌾" or "",
        " ",
    })
end

---@return string
function M.diagnostics()
    local diag_count = vim.diagnostic.count(0)
    local errors = diag_count[1] or 0
    local warnings = diag_count[2] or 0
    local infos = diag_count[3] or 0
    local hints = diag_count[4] or 0

    local err = errors > 0 and hl_segment(string.format("%s %s ", icons.diagnostics.Error, errors), "DiagnosticError")
        or ""
    local warn = warnings > 0
            and hl_segment(string.format("%s %s ", icons.diagnostics.Warn, warnings), "DiagnosticWarn")
        or ""
    local info = infos > 0 and hl_segment(string.format("%s %s ", icons.diagnostics.Info, infos), "DiagnosticInfo")
        or ""
    local hint = hints > 0 and hl_segment(string.format("%s %s ", icons.diagnostics.Hint, hints), "DiagnosticHint")
        or ""

    return table.concat({ err, warn, info, hint })
end

-- local function get_venv()
--     local venv = os.getenv("VIRTUAL_ENV")
--     local output = ""
--     if venv then
--         output = string.match(venv, "([^/]+)$")
--         output = string.format("(%s)", output)
--     end
--
--     return output
-- end

local function get_lsp()
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if vim.tbl_isempty(clients) then
        return "inactive"
    end

    local names = {}
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and (vim.fn.index(filetypes, buf_ft) ~= -1 or client.config.name == "zk") then
            table.insert(names, client.name)
        end
    end

    return table.concat(names, ",")
end

local function get_formatters()
    local formatters = require("conform").list_formatters(0)
    local output = ""
    if not vim.tbl_isempty(formatters) then
        local names = {}
        for _, formatter in ipairs(formatters) do
            local name = formatter.name
            if formatter.name == "ruff_organize_imports" then
                name = "ruff_imp"
            elseif formatter.name == "ruff_format" then
                name = "ruff_fmt"
            end
            table.insert(names, name)
        end

        output = string.format("[%s]", table.concat(names, ","))
    end

    return output
end

local function get_linters()
    local linters = require("lint").get_running()
    if #linters == 0 then
        return ""
    end

    return string.format("[%s]", table.concat(linters, ","))
end

---@return string
function M.tools()
    return table.concat({
        " LSP: ",
        get_lsp(),
        get_formatters(),
        get_linters(),
        " ",
    })
end

---@return string
function M.qf_list()
    local qfl = vim.fn.getqflist()
    return #qfl > 0 and string.format(" QF: %d ", #qfl) or ""
end

---@return string
function M.encoding()
    local encoding = vim.opt.fileencoding:get()
    -- return encoding ~= "" and string.format("%%#StatuslineSectionInner# %s ", encoding) or ""
    return encoding ~= "" and hl_segment(string.format(" %s ", encoding), "StatuslineSectionInner") or ""
end

---@return string
-- function M.filetype()
--     local filetype = vim.bo.filetype
--     local icon, hl = mini_icons.get("filetype", filetype)
--     return table.concat({
--         hl_segment(icon, hl),
--         " ",
--         filetype,
--         "  ",
--     })
-- end

---@return string
function M.cursor_pos()
    local cur_pos = vim.fn.getcursorcharpos()
    local cur_line, cur_col = cur_pos[2], cur_pos[3]
    local num_lines = vim.api.nvim_buf_line_count(0)
    -- local _col = vim.fn.virtcol(".")

    -- return string.format("%%#StatuslineSectionOuter# [%d, %d] %d ", cur_line, cur_col, num_lines)
    -- %P = percentage through file of displayed window
    return hl_segment(string.format(" [%d, %d] %%P ", cur_line, cur_col, num_lines), "StatuslineSectionOuter")
end

---@return string
function M.render()
    return table.concat({
        M.mode(),
        M.git_status(),
        M.file(),
        "%#Statusline#%=",
        M.diagnostics(),
        M.tools(),
        M.qf_list(),
        -- M.filetype(),
        M.encoding(),
        M.cursor_pos(),
    })
end

vim.o.statusline = "%!v:lua.require('winter-again.statusline').render()"

return M
