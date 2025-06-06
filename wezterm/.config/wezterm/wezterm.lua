local wezterm = require("wezterm")
local utils = require("utils")

local config = {}
-- WARNING: seems like using wezterm.config_builder()
-- breaks things with wezterm-config.nvim but only inside of tmux
-- logs show that the user vars that wezterm shell integration defines are invalid?
-- https://wezfurlong.org/wezterm/shell-integration.html?h=shell#user-vars
-- opened issue here: https://github.com/wez/wezterm/issues/5078#issue-2153349617
--
-- allows working w/ current release and nightly:
if wezterm.config_builder then
    config = wezterm.config_builder() -- allows better logging of warnings and errors
end

-- config.front_end = "WebGpu" -- default is OpenGL
-- trying this since it's technically using the dGPU now; unsure of whether one is clearly better
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[2]
config.warn_about_missing_glyphs = false
-- config.enable_wayland = true -- already default
config.audible_bell = "Disabled"
config.default_cwd = wezterm.home_dir
config.check_for_updates = false
config.term = "wezterm" -- must install wezterm terminfo file: https://wezfurlong.org/wezterm/config/lua/config/term.html

local color_schemes = {
    "Tokyo Night",
    -- https://github.com/mountain-theme/Mountain/tree/48b5732a2368a0ff75081108a88c126ded5ab73d/Wezterm
    "Mountain", -- seems close enough to mellifluous mountain
    "Catppuccin Mocha",
    "Kanagawa (Gogh)",
    "rose-pine",
}
config.color_scheme = color_schemes[2]
config.background = require("bg").set_bg()
config.font, config.font_size = utils.set_font_properties("Zed")
-- this needs explicit setting if not the default
-- config.xcursor_theme = 'capitaine-cursors-light'
-- config.xcursor_size = 32 -- this works fine
-- config.freetype_load_flags = 'NO_HINTING' -- now default
config.cursor_blink_rate = 0
config.window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true
config.bypass_mouse_reporting_modifiers = "CTRL" -- use CTRL to bypass app mouse repoorting (for hyperlinks)
-- https://wezfurlong.org/wezterm/config/mouse.html#configuring-mouse-assignments
config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = "Left" } },
        modds = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
    {
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
    {
        key = "s",
        mods = "LEADER",
        action = wezterm.action.EmitEvent("send-txt-to-pane"),
    },
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
