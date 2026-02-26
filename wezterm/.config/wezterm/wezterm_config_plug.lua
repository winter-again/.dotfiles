-- NOTE: this is just for testing purposes to avoid
-- having to mess with the wezterm plugin repos/directory directly
local wezterm = require("wezterm")
local M = {}

---Interpret the Wezterm user var that got overridden and use a specific helper
---function to apply overrides to the passed overrides table; for use within
---a callback function in Wezterm config
---@param overrides table
---@param name string
---@param value string
---@return table
function M.override_user_var(overrides, name, value)
    -- TODO: figure out how to just have one override func
    -- aka detect whether the value passed is table or something simple
    -- may have to put some condition on whether json_parse() works on the value?
    -- or do a check before calling parse func

    -- returns tbl if successfully parsed
    -- otherwise it returns 1 (?) so I guess an error code or at least
    -- something with type == 'number'
    local parsed_val = wezterm.json_parse(value)
    if type(parsed_val) == "table" then
        overrides[name] = parsed_val
    else
        if value == "true" or value == "false" then
            -- convert to bool
            value = value == "true"
        elseif string.match(value, "^%d*%.?%d+$") then
            -- convert to number
            value = tonumber(value)
        end
        overrides[name] = value
    end
    return overrides
end

return M
