--- @diagnostic disable: missing-fields
return {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            event = { "BufReadPost", "BufNewFile" },
            dependencies = "nvim-treesitter/nvim-treesitter",
            config = function()
                require("ts_context_commentstring").setup({
                    -- disable default autocmd for Comment.nvim
                    enable_autocmd = false,
                })
            end,
        },
    },
    config = function()
        require("Comment").setup({
            -- LHS of toggle mappings in normal mode
            -- toggles commenting for current line
            toggler = {
                line = "mcc",
                block = "mcb",
            },
            -- LHS of operator-pending maps in normal and visual mode
            -- can use to comment two lines down with 'gb2j' for ex or after selection
            opleader = {
                line = "mc",
                block = "mb",
            },
            extra = {
                above = "gcO",
                below = "gco",
                eol = "gcA",
            },
            mappings = {
                basic = true,
                extra = false, -- disable mappings
            },
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })
    end,
}
