local function get_venv()
    local venv = os.getenv('VIRTUAL_ENV')
    local output = ''
    if venv then
        output = string.match(venv, '([^/]+)$')
        output = string.format('(%s)', output)
    end
    return output
end

local function get_lsp()
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if vim.tbl_isempty(clients) then
        return 'None active'
    else
        local names = {}
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                table.insert(names, client.name)
            end
        end
        return table.concat(names, ',')
    end
end

local function get_conform()
    -- local lsp_format = require('conform.lsp_format')
    local formatters = require('conform').list_formatters(0)
    local output = ''
    if not vim.tbl_isempty(formatters) then
        local names = {}
        for _, formatter in ipairs(formatters) do
            table.insert(names, formatter.name)
        end
        output = table.concat(names, ', ')
        output = string.format('[%s]', output)
    end
    return output
end

local function display_lsp_venv()
    return get_lsp() .. get_conform() .. get_venv()
end

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
                globalstatus = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    {
                        'b:gitsigns_head',
                        icon = '',
                    },
                    {
                        'diff',
                        source = diff_source,
                        symbols = { added = ' ', modified = ' ', removed = ' ' },
                    },
                    {
                        'diagnostics',
                        sources = { 'nvim_lsp' },
                        sections = { 'error', 'warn', 'info', 'hint' },
                        -- lualine has its own default icons
                        symbols = {
                            error = ' ',
                            warn = ' ',
                            hint = ' ', -- default = 󰌶
                            info = ' ',
                        },
                    },
                },
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = { 'encoding', 'filetype', { display_lsp_venv, icon = { ' LSP:' } } },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
            extensions = { 'nvim-tree', 'fugitive' },
        })
    end,
}
