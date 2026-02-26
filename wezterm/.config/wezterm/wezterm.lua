local wezterm = require("wezterm")
local utils = require("utils")

local config = {}

-- WARNING: seems like using wezterm.config_builder()
-- breaks things with wezterm-config.nvim but only inside of tmux
-- logs show that the user vars that wezterm shell integration defines are invalid?
-- https://wezfurlong.org/wezterm/shell-integration.html?h=shell#user-vars
-- opened issue here: https://github.com/wez/wezterm/issues/5078#issue-2153349617

-- allows working w/ current release and nightly:
if wezterm.config_builder then
    config = wezterm.config_builder() -- allows better logging of warnings and errors
end

config.color_scheme = "Mountain"
config.background = require("bg").set_bg()
config.font, config.font_size = utils.set_font_properties("Zed")
config.cursor_blink_rate = 0
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true
config.bypass_mouse_reporting_modifiers = "CTRL" -- use CTRL to bypass app mouse repoorting (for hyperlinks)
-- config.front_end = "WebGpu" -- default is OpenGL
config.warn_about_missing_glyphs = false
config.audible_bell = "Disabled"
config.default_cwd = wezterm.home_dir
config.check_for_updates = false
config.term = "wezterm" -- must install wezterm terminfo file: https://wezfurlong.org/wezterm/config/lua/config/term.html
config.mouse_bindings = {
    -- see: https://wezfurlong.org/wezterm/config/mouse.html#configuring-mouse-assignments
    {
        -- CTRL-click to open hyperlinks
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
    {
        -- disable "Down" event of CTRL-click to avoid weird behaviors
        event = { Down = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.Nop,
    },
}
config.leader = { key = "m", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    { key = "o", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
    { key = "p", mods = "LEADER", action = wezterm.action.PaneSelect({ alphabet = "123456789" }) },
    {
        key = "c",
        mods = "LEADER",
        action = wezterm.action.EmitEvent("clear-overrides"),
    },
    -- {
    --     key = "s",
    --     mods = "LEADER",
    --     action = wezterm.action.EmitEvent("send-txt-to-pane"),
    -- },
    {
        key = "u",
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane)
            wezterm.plugin.update_all()
            window:toast_notification("wezterm", "Updated plugins", nil, 2000)
        end),
    },
}

-- plugins
-- I think because I have `$XDG_RUNTIME_DIR` set, my plugins are in ~/.local/share/wezterm/plugins
-- otherwise check `/run/user/1000/wezterm/plugins/`
-- only http or local filesystem repos are allowed
-- local wezterm_config_nvim = wezterm.plugin.require("https://github.com/winter-again/wezterm-config.nvim")
local wezterm_config_nvim =
    wezterm.plugin.require("file:///home/winteragain/Documents/code/nvim-dev/wezterm-config.nvim")
-- local wezterm_config_nvim = require('wezterm_config_plug')

-- wezterm.plugin.update_all()

-- callbacks
wezterm.on("user-var-changed", function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    print("------------------------------------")
    print("OVERRIDES PRE:")
    print(overrides)

    print(string.format("USER VAR: %s: %s", name, value))

    local parsed_val = wezterm.json_parse(value)
    -- local ok, parsed_val = pcall(wezterm.json_parse, value)
    local parsed_val_type = type(parsed_val)
    print(string.format("PARSED DATA: %s = %s (type: %s)", name, parsed_val, parsed_val_type))
    print(parsed_val)

    if name == "font" then
        print("wezterm.font(...):")
        print(wezterm.font(value))
    end

    overrides = wezterm_config_nvim.override_user_var(overrides, name, value)
    window:set_config_overrides(overrides)
end)

wezterm.on("clear-overrides", function(window, pane)
    window:set_config_overrides({})
    -- NOTE: timeout doesn't actually work
    window:toast_notification("wezterm", "Config overrides cleared", nil, 2000)
end)

-- wezterm.on('send-txt-to-pane', function(window, pane, name, value)
--     -- this works
--     local msg = 'Hi, mom. This is a custom message.'
--     utils.send_text(pane, msg)
-- end)

return config
