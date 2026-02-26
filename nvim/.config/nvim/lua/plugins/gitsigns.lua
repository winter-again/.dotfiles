--- @diagnostic disable: param-type-mismatch
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            current_line_blame_formatter = "<author> • <author_time:%Y-%m-%d> • <summary>",
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local map = require("winteragain.globals").map
                local opts = { silent = true, buffer = bufnr }

                map("n", "]h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]h", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, opts, "Next hunk")
                map("n", "[h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]h", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, opts, "Previous hunk")

                map("n", "<leader>gb", gs.toggle_current_line_blame, opts, "Toggle git blame for current line")
                map("n", "<leader>hd", gs.preview_hunk, opts, "Show hunk diff")
                map("n", "<leader>hs", gs.stage_hunk, opts, "Toggle hunk stage")
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, opts, "Toggle hunk stage")
                map("n", "<leader>hr", gs.reset_hunk, opts, "Reset hunk")
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, opts, "Reset hunk")
                map("n", "<leader>hq", function()
                    gs.setqflist("all")
                end, opts, "Send diff hunks to qflist")
            end,
        })
    end,
}
