return {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local builtin = require("statuscol.builtin")

        local function ignore_ft()
            local ignore = {
                "oil",
            }
            local file_type = vim.bo.filetype
            return not vim.tbl_contains(ignore, file_type)
        end
        require("statuscol").setup({
            relculright = true, -- align the current line number with rest of col
            segments = {
                {
                    -- diagnostics
                    sign = {
                        namespace = { "diagnostic" },
                        colwidth = 1, -- num of cells to display *per sign*; can act as padding I think
                        maxwidth = 1, -- max num of signs to display
                        auto = false, -- when true, segment not drawn if no signs match
                    },
                    condition = {
                        ignore_ft,
                    },
                    -- click = "v:lua.ScSa", -- get sign action
                },
                {
                    -- default line nums
                    -- elements of text are controlled by elements of conditon
                    text = {
                        builtin.lnumfunc,
                        " ",
                    },
                    condition = {
                        true,
                        builtin.not_empty, -- only show padding when rest of statuscolumn has content
                    },
                    -- click = "v:lua.ScLa", -- get lnum action
                },
                {
                    sign = {
                        namespace = { "gitsigns" }, -- namespace for builtin click actions
                        colwidth = 1,
                        maxwidth = 1,
                        auto = false,
                    },
                    condition = {
                        ignore_ft,
                    },
                    -- click = "v:lua.ScSa", -- get sign action
                },
            },
        })
    end,
}
