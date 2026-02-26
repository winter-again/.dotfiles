--- @diagnostic disable: missing-fields
return {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("Comment").setup({
            -- LHS of toggle mappings in normal mode
            -- toggles commenting for current line
            toggler = {
                -- line = '<C-_>',
                line = "mcc",
                block = "mcb",
            },
            -- LHS of operator-pending maps in normal and visual mode
            -- can use to comment two lines down with 'gb2j' for ex or after selection
            opleader = {
                -- line = '<C-_>',
                line = "mc",
                block = "mb",
            },
            extra = {
                above = "mcO",
                below = "mco",
                eol = "mce",
            },
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })
    end,
}
