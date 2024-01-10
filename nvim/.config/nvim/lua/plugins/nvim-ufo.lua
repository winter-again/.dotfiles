return {
    'kevinhwang91/nvim-ufo',
    enabled = false,
    dependencies = {
        'kevinhwang91/promise-async',
        'luukvbaal/statuscol.nvim',
    },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { silent = true })
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { silent = true })
        -- use same keymap as lspsaga to preview the fold but handle it nicely
        vim.keymap.set('n', 'K', function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
                vim.cmd('Lspsaga hover_doc')
            end
        end)
        -- handler function for customizing the virtual text displayed by fold line
        -- https://github.com/kevinhwang91/nvim-ufo#customize-fold-text
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (' 󰁂 %d '):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, 'MoreMsg' })
            return newVirtText
        end
        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return { 'treesitter', 'indent' }
            end,
            fold_virt_text_handler = handler,
        })
    end,
}
