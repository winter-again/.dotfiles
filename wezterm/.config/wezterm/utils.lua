local wezterm = require("wezterm")
local profile_data = require("lua.profile_data")

local M = {}

---@param bg_name string
---@return table
function M.set_bg(bg_name)
    local bg_key
    if bg_name ~= "default" and bg_name ~= "black" then
        bg_key = "bg_" .. bg_name
    else
        bg_key = bg_name
    end
    return profile_data.background[bg_key].background
end

---Log info about user var value and config overrides to .txt file in /run/user/1000/wezterm
---@param value string
---@param overrides table
function M.log_overrides(value, overrides)
    local parsed_val = wezterm.json_parse(value)
    print("PARSED VALUE:")
    print(parsed_val)
    print("OVERRIDES:")
    print(overrides)
end

function M.notif_overrides(pane, name)
    local pane_id = pane:pane_id()
    local user_vars = pane:get_user_vars()
    local vars_json_enc = wezterm.json_encode(user_vars)
    local user_var = user_vars[name]
    local msg = ("%s=%s"):format(name, user_var)
    return pane_id, msg
end

---Send arbitrary text to given pane
function M.send_text(pane, msg)
    pane:send_text(msg)
end

return M
