return {
    'kevinhwang91/nvim-hlslens',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
        require('hlslens').setup({
            calm_down = false, -- true will clear all lens and highlighting when cursor is out of position range or any text changed
            -- customize virt text
            -- override_lens = function(render, posList, nearest, idx, relIdx)
            --     local sfw = vim.v.searchforward == 1
            --     local indicator, text, chunks
            --     local absRelIdx = math.abs(relIdx)
            --     if absRelIdx > 1 then
            --         indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
            --     elseif absRelIdx == 1 then
            --         indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
            --     else
            --         indicator = ''
            --     end
            --
            --     local lnum, col = unpack(posList[idx])
            --     if nearest then
            --         local cnt = #posList
            --         if indicator ~= '' then
            --             text = ('[%s %d/%d]'):format(indicator, idx, cnt)
            --         else
            --             text = ('[%d/%d]'):format(idx, cnt)
            --         end
            --         chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
            --     else
            --         text = ('[%s %d]'):format(indicator, idx)
            --         chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
            --     end
            --     render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
            -- end,
        })
        local opts = { silent = true }
        -- jump through results
        vim.keymap.set(
            'n',
            'n',
            [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
            opts
        )
        vim.keymap.set(
            'n',
            'N',
            [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
            opts
        )
        -- support for
        -- '*' = find previous occurrence of word under cursor
        -- '#' = find next occurrence of word under cursor
        vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
        -- like the above but allows partial matching of word
        vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)
    end,
}
