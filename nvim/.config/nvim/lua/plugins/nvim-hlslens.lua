return {
    "kevinhwang91/nvim-hlslens",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("hlslens").setup({
            calm_down = false, -- true will clear all lens and highlighting when cursor is out of position range or any text changed
        })

        local map = require("winter-again.globals").map
        local opts = { silent = true }
        map(
            "n",
            "n",
            [[<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>]],
            opts,
            "Next search result"
        )
        map(
            "n",
            "N",
            [[<cmd>execute('normal! ' . v:count1 . 'N')<CR><cmd>lua require('hlslens').start()<CR>]],
            opts,
            "Previous search result"
        )
        map(
            "n",
            "*",
            [[*<cmd>lua require('hlslens').start()<CR>]],
            opts,
            "Find previous occurrence of word under cursor"
        )
        map("n", "#", [[#<cmd>lua require('hlslens').start()<CR>]], opts, "Find next occurrence of word under cursor")
        map(
            "n",
            "g*",
            [[g*<cmd>lua require('hlslens').start()<CR>]],
            opts,
            "Find previous occurrence of word with partial matching"
        )
        map(
            "n",
            "g#",
            [[g#<cmd>lua require('hlslens').start()<CR>]],
            opts,
            "Find next occurrence of word with partial matching"
        )
    end,
}
