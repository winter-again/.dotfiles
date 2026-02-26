local wezterm = require('wezterm')
local profile_data = require('lua.profile_data')

local M = {}

function M.set_bg(bg_name)
    local bg_key = 'bg_' .. bg_name
    return profile_data.background[bg_key]
end

-- TODO: can make this accept the attributes table and pass on to wezterm.font()?
-- so that we can specify font and font size together in a single table
-- in profile_data.lua? is it even worth it?
function M.set_font(font_name)
    local font_key = 'font_' .. font_name
    local font = wezterm.font(profile_data.font[font_key])
    return font
end

return M
