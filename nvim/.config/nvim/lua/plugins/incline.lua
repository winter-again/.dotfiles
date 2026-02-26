return {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
        require("incline").setup({
            window = {
                placement = { vertical = "top", horizontal = "right" },
                padding = { left = 0, right = 0 },
                margin = { vertical = 0, horizontal = 0 },
                overlap = { winbar = true, borders = true },
            },
            hide = {
                cursorline = true, -- hide when cursor on same line
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":p:~:.")
                if filename == "" then
                    filename = "[No name]"
                end
                local modified = vim.bo[props.buf].modified
                local read_only = vim.api.nvim_get_option_value("readonly", { buf = props.buf })

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
