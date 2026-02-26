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

return M
