local wezterm = require('wezterm')
local M = {}

function M.apply_to_config(config)
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
