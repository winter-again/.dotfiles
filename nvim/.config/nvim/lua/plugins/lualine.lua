-- function that gets virtual environment name and can be sent to lualine
-- caveat is that it only works if we manually activate virtual env first
-- if we only specified it in pyrightconfig.json, then pyright picks it up properly
-- but lualine component won't know and thus it won't be shown
-- inspired from here: https://github.com/nvim-lualine/lualine.nvim/issues/277
local function get_venv()
    local output = ''
    local venv = vim.env.VIRTUAL_ENV
    if venv then
        output = string.match(venv, '([^/]+)$')
        output = string.format('(%s)', output)
    end
    return output
end

-- display attached LSP client if there is one
local function get_lsp()
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return 'None active'
    else
        local names = {}
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                table.insert(names, client.name)
            end
        end
        local output = table.concat(names, ',')
        return output
    end
end

-- display formatter information from conform if avail
local function get_conform()
    local output = ''
    local formatters = require('conform').list_formatters(0)
    if next(formatters) == nil then
        return output
    else
        local names = {}
        for _, formatter in ipairs(formatters) do
            table.insert(names, formatter.name)
        end
        output = table.concat(names, ', ')
        output = string.format('[%s]', output)
        return output
    end
end

local function display_lsp_venv()
    local venv_name = get_venv()
    local lsp_status = get_lsp()
    local formatter = get_conform()
    return lsp_status .. formatter .. venv_name
end

-- basic way to display loading prog of LSP
-- local function display_lsp_prog()
--     local lsp = vim.lsp.util.get_progress_messages()[1]
--     if lsp then
--         local name = lsp.name or ''
--         local msg = lsp.message or ''
--         local pctg = lsp.percentage or 0
--         return string.format('%%<%s: %s (%s%%%%)', name, msg, pctg)
--     else
--         return ''
--     end
-- end

-- use gitsigns as the diff source below
local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
    end
end

return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                -- disabled_filetypes = {
                --     winbar = { 'NvimTree', 'alpha' },
                -- },
                globalstatus = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
            },
            -- most of this is default
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    -- reuse info from gitsigns
                    {
                        'b:gitsigns_head',
                        icon = '',
                    },
                    {
                        'diff',
                        source = diff_source,
                        symbols = { added = ' ', modified = ' ', removed = ' ' },
                    },
                    'diagnostics',
                },
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = { 'encoding', 'filetype', { display_lsp_venv, icon = { ' LSP:' } } },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
            -- winbar = {
            --     lualine_c = { { 'filename', path = 3 } },
            -- },
            -- inactive_winbar = {
            --     lualine_c = { { 'filename', path = 3 } },
            -- },
            extensions = { 'nvim-tree', 'fugitive' },
        })
    end,
}
