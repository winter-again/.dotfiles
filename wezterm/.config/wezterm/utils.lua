local wezterm = require('wezterm')
local profile_data = require('lua.profile_data')

local M = {}

---@param bg_name string
---@return table
function M.set_bg(bg_name)
    local bg_key = 'bg_' .. bg_name
    return profile_data.background[bg_key]
end

-- TODO: can make this accept the attributes table and pass on to wezterm.font()?
-- so that we can specify font and font size together in a single table
-- in profile_data.lua? is it even worth it?

---@param font_name string
---@return table
function M.set_font(font_name)
    local font_key = 'font_' .. font_name
    local font = wezterm.font(profile_data.font[font_key])
    return font
end

---@param config table
function M.wayland_config(config)
    local xcursor_size = nil
    local xcursor_theme = nil

    local success, stdout, stderr =
        wezterm.run_child_process({ 'gsettings', 'get', 'org.gnome.desktop.interface', 'cursor-theme' })
    if success then
        config.xcursor_theme = stdout:gsub("'(.+)'\n", '%1')
    end

    local success, stdout, stderr =
        wezterm.run_child_process({ 'gsettings', 'get', 'org.gnome.desktop.interface', 'cursor-size' })
    if success then
        config.xcursor_size = tonumber(stdout)
    end
end

---Log info about user var value and config overrides to .txt file in /run/user/1000/wezterm
---@param value string
---@param overrides table
function M.log_overrides(value, overrides)
    local parsed_val = wezterm.json_parse(value)
    print('PARSED VALUE:')
    print(parsed_val)
    print('OVERRIDES:')
    print(overrides)
end

function M.notif_overrides(pane, name)
    local pane_id = pane:pane_id()
    local user_vars = pane:get_user_vars()
    local vars_json_enc = wezterm.json_encode(user_vars)
    local user_var = user_vars[name]
    local msg = ('%s=%s'):format(name, user_var)
    return pane_id, msg
end

---Send arbitrary text to given pane
function M.send_text(pane, msg)
    pane:send_text(msg)
end

return M
