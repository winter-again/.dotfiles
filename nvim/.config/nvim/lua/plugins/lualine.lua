local function get_venv()
    local venv = os.getenv("VIRTUAL_ENV")
    local output = ""
    if venv then
        output = string.match(venv, "([^/]+)$")
        output = string.format("(%s)", output)
    end

    return output
end

local function get_lsp()
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if vim.tbl_isempty(clients) then
        return "Inactive"
    end

    local names = {}
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 or client.config.name == "zk" then
            table.insert(names, client.name)
        end
    end

    return table.concat(names, ",")
end

local function get_conform()
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

local function get_nvim_lint()
    local linters = require("lint").get_running()
    if #linters == 0 then
        return ""
    end

    return string.format("[%s]", table.concat(linters, ","))
end

local function display_tools()
    return get_lsp() .. get_conform() .. get_nvim_lint() .. get_venv()
end

-- use gitsigns as the diff source below
local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
    end
end

local function qflist()
    local qfl = vim.fn.getqflist()
    return #qfl
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                globalstatus = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        "b:gitsigns_head",
                        icon = "",
                    },
                    {
                        "diff",
                        source = diff_source,
                        symbols = {
                            added = " ",
                            modified = " ",
                            removed = " ",
                            -- added = "+",
                            -- modified = "~",
                            -- removed = "-",
                        },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        sections = { "error", "warn", "info", "hint" },
                        -- lualine has its own default icons
                        symbols = {
                            error = " ",
                            warn = " ",
                            hint = " ", -- default = 󰌶
                            info = " ",
                        },
                        colored = true,
                        update_in_insert = true,
                        always_visible = false,
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        file_status = true,
                        path = 3,
                    },
                },
                lualine_x = {
                    -- "encoding",
                    "filetype",
                    {
                        display_tools,
                        icon = { " LSP:" },
                    },
                    { qflist, icon = { " QF:" } },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = {
                "fugitive",
                "quickfix",
                "trouble",
            },
        })
    end,
}
