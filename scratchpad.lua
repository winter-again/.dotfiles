local function find_refs()
    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_position_params()
    local ns = vim.api.nvim_create_namespace('WinterAgainRename')
    params.context = { includeDeclaration = true }
    local clients = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/references' })
    if #clients == 0 then
        return
    end

    clients[1].request('textDocument/references', params, function(_, result)
        if not result then
            return
        end

        for _, v in ipairs(result) do
            if v.range then
                local buf = vim.uri_to_bufnr(v.uri)
                local line = v.range.start.line
                local start_char = v.range.start.character
                local end_char = v.range['end'].character
                if buf == bufnr then
                    vim.api.nvim_buf_add_highlight(bufnr, ns, 'RenameMatch', line, start_char, end_char)
                end
            end
        end
    end, bufnr)

    vim.lsp.buf.rename()
end

vim.keymap.set('n', '<leader>rn', find_refs)
-- to clear hl
-- vim.api.nvim_set_hl(0, 'RenameMatch', {})
local foo = 'bar'
print(foo)
