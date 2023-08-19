-- function that gets virtual environment name and can be sent to lualine
-- caveat is that it only works if we manually activate virtual env first
-- if we only specified it in pyrightconfig.json, then pyright picks it up properly
-- but lualine component won't know and thus it won't be shown
-- inspired from here: https://github.com/nvim-lualine/lualine.nvim/issues/277
local function get_venv()
    local venv = vim.env.VIRTUAL_ENV
    if venv then
        local venv_text = string.match(venv, '([^/]+)$')
        return venv_text
    else
        return ''
    end
end

-- display attached LSP client if there is one
-- from this ex: https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua
local function get_lsp()
    local msg = 'None active'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return msg
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= 'null-ls' then
            return client.name
        end
    end
    return msg
end

local function get_null_ls()
    local buf_ft = vim.bo.filetype
    local sources = require('null-ls').get_source({filetype=buf_ft})
    if next(sources) ~= nil then
        local src_list = {}
        for _, source in pairs(sources) do
            table.insert(src_list, source.name)
        end
        local str_sources = table.concat(src_list, ', ')
        local msg = string.format('[%s]', str_sources)
        return msg
    else
        return 'None active'
    end
end


-- combine these two functions into a single section's output
-- a bit hacky but checks if there's an active virtual environment and
-- adds it to the LSP indicator
local function display_lsp_venv()
    local venv_name = get_venv()
    local lsp_status = get_lsp()
    local null_ls = get_null_ls()
    if lsp_status ~= 'None active' and null_ls ~= 'None active' and venv_name ~= '' then
        return lsp_status .. null_ls .. ' (' .. venv_name .. ')'
    elseif lsp_status ~= 'None active' and null_ls ~= 'None active' and venv_name == '' then
        return lsp_status .. null_ls
    elseif lsp_status ~= 'None active' and null_ls == 'None active' and venv_name ~= '' then
        return lsp_status .. ' (' .. venv_name .. ')'
    -- elseif lsp_status ~= 'None active' and null_ls == 'None active' and venv_name == '' then
        -- return lsp_status
    -- elseif lsp_status == 'None active' then
    else
        return lsp_status
    end
end

-- use gitsigns as the diff source below
local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed}
    end
end

return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        -- local colors = require('tokyonight.colors').setup() -- get the Tokyonight colors
        require('lualine').setup({
            options = {
                disabled_filetypes = {
                    winbar = {'NvimTree','alpha'}
                },
                globalstatus = true,
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
            },
            -- most of this is default
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', {'diff', source=diff_source}, 'diagnostics'},
                lualine_c = {{'filename', path=1}},
                lualine_x = {'filetype', {display_lsp_venv, icon={' LSP:'}}},
                lualine_y = {'progress'},
                lualine_z = {'location'}
              },
            winbar = {
                lualine_c = {{'filename', path=3}}
            },
            inactive_winbar = {
                lualine_c = {{'filename', path=3}}
            },
            extensions = {'nvim-tree', 'fugitive'}
        })
    end
}
