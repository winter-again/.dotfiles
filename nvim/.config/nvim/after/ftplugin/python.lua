---@return table | nil
local function get_windows()
    local windows = vim.fn.systemlist("tmux list-windows -F '#{window_index}'")
    if windows == "" then
        return
    end
    return windows
end

local function uv_run_cur_module()
    local cur_win = vim.fn.systemlist("tmux display-message -p -F '#{window_index}'")[1]
    local windows = get_windows()
    if windows ~= nil then
        local next_win = tostring(tonumber(cur_win) + 1)
        if vim.tbl_contains(windows, next_win) then
            -- NOTE: src/kintsugi/impute.py
            local cur_file = vim.fn.expand("%:r"):gsub("/", ".")
            local cmd = string.format("tmux send-keys -t %d 'uv run -m %s' Enter", next_win, cur_file)
            vim.fn.systemlist(cmd)
        end
    else
        print("Error getting tmux windows")
    end
end

vim.api.nvim_create_user_command("Tmux", function(args)
    local sub_cmd = args.fargs[1]
    local arg = args.fargs[2]

    -- NOTE: restricted choices
    if sub_cmd == "uv" then
        uv_run_cur_module()
    end
end, {
    nargs = 1,
    -- arg_lead = the leading portion of the arg currently being completed on
    -- cmd_line = the entire command line
    -- cursor_pos = the cursor position in it (byte index)
    complete = function(arg_lead, cmd_line, cursor_pos)
        local choices = { "uv" }
        return choices
    end,
    desc = "Use tmux",
})
