return {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
        require("incline").setup({
            window = {
                placement = { vertical = "top", horizontal = "right" },
                padding = { left = 0, right = 0 },
                -- these don't satisfy the len 1 validator
                -- padding_char = "▌",
                -- padding_char = "",
                margin = { vertical = 0, horizontal = 0 },
                overlap = { winbar = true, borders = true },
            },
            render = function(props)
                -- local function word_count()
                --     return string.format("(%s W)", vim.fn.wordcount().words)
                -- end

                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":p:~:.")
                if filename == "" then
                    filename = "[No Name]"
                end
                local modified = vim.bo[props.buf].modified
                local read_only = vim.api.nvim_get_option_value("readonly", { buf = props.buf })

                -- note: vim.fn.wordcount() only works on current buffer rather than target
                -- local ft = vim.api.nvim_get_option_value("filetype", { buf = props.buf })
                -- if ft == "markdown" then
                --     filename = string.format("%s %s", filename, word_count())
                -- end

                return {
                    filename,
                    " ",
                    modified and "[+]" or "",
                    read_only and " 󰌾" or "",
                }
            end,
        })
    end,
}
