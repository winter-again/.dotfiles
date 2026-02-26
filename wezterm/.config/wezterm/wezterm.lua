local wezterm = require('wezterm')
-- local profile_data = require('lua.profile_data')
local utils = require('utils')

-- allows working w/ current release and nightly
local config = {}

-- WARNING: seems like using wezterm.config_builder()
-- breaks things with wezterm-config.nvim but only inside of tmux
-- logs show that the user vars that wezterm shell integration defines are invalid?
-- https://wezfurlong.org/wezterm/shell-integration.html?h=shell#user-vars
-- opened issue here: https://github.com/wez/wezterm/issues/5078#issue-2153349617
--
-- if wezterm.config_builder then
--     config = wezterm.config_builder() -- allows better logging of warnings and errors
-- end

-- trying this since it's technically using the dGPU now; unsure of whether one is clearly better
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[2]
-- config.front_end = 'WebGpu'
-- config.warn_about_missing_glyphs = false
-- config.enable_wayland = true
config.front_end = 'OpenGL'
config.audible_bell = 'Disabled'
config.default_prog = { '/usr/bin/zsh' }
config.default_cwd = wezterm.home_dir
config.color_scheme = 'tokyonight_night' -- builtin colorscheme (Folke ver)
config.check_for_updates = false
-- setting this here also causes partial line problems
-- config.term = 'wezterm' -- https://wezfurlong.org/wezterm/config/lua/config/term.html

config.background = utils.set_bg('16')
config.font = utils.set_font('1')
config.font_size = 12.0
-- this needs explicit setting if not the default
config.xcursor_theme = 'capitaine-cursors-light'
config.xcursor_size = 32 -- this works fine
config.freetype_load_flags = 'NO_HINTING' -- use this to keep curly braces {} nicely aligned
config.cursor_blink_rate = 0
config.window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true
config.colors = {
    tab_bar = {
        active_tab = {
            bg_color = '#16161e',
            fg_color = '#c0caf5',
        },
        inactive_tab = {
            bg_color = '#1a1b26',
            fg_color = '#737aa2',
        },
        inactive_tab_hover = {
            bg_color = '#24283b',
            fg_color = '#c0caf5',
        },
        inactive_tab_edge = '#c0caf5',
        new_tab = {
            bg_color = '#16161e',
            fg_color = '#c0caf5',
        },
        new_tab_hover = {
            bg_color = '#24283b',
            fg_color = '#c0caf5',
        },
    },
}
config.window_frame = {
    font = wezterm.font('Hack Nerd Font Mono'),
    font_size = 10.0,
    active_titlebar_bg = '#1d202f', -- color of the space behind tabs
    inactive_titlebar_bg = '#1d202f',
}
config.use_fancy_tab_bar = true -- default
config.show_tab_index_in_tab_bar = true
-- mouse and keys
config.bypass_mouse_reporting_modifiers = 'CTRL' -- use CTRL to bypass app mouse repoorting (for hyperlinks)
config.leader = { key = 'm', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    { key = 'o', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay },
    { key = 'p', mods = 'LEADER', action = wezterm.action.PaneSelect({ alphabet = '123456789' }) },
    {
        key = 'c',
        mods = 'LEADER',
        action = wezterm.action.EmitEvent('clear-overrides'),
    },
    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action.EmitEvent('send-txt-to-pane'),
    },
}
-- config.keys = {
--     {
--         key = 'N',
--         mods = 'CTRL|SHIFT',
--         action = wezterm.action.SpawnCommandInNewTab({
--             cwd = wezterm.home_dir,
--         }),
--     },
--     -- tab navigation
--     { key = 'Q', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivateTab = 0 }) },
--     { key = 'W', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivateTab = 1 }) },
--     { key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivateTab = 2 }) },
--     { key = 'R', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivateTab = 3 }) },
--     -- tab navigation but cycling
--     { key = '{', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
--     { key = '}', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
--     -- create splits
--     {
--         key = '|',
--         mods = 'CTRL|SHIFT',
--         action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }),
--     },
--     {
--         key = '_',
--         mods = 'CTRL|SHIFT',
--         action = wezterm.action({ SplitVertical = { domain = 'CurrentPaneDomain' } }),
--     },
--     -- pane navigation rebinds
--     { key = 'H', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Left') },
--     { key = 'J', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Down') },
--     { key = 'K', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Up') },
--     { key = 'L', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Right') },
--     -- resize panes
--     { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({ 'Left', 2 }) },
--     { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({ 'Right', 2 }) },
--     { key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({ 'Up', 2 }) },
--     { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({ 'Down', 2 }) },
--     { key = 'M', mods = 'CTRL|SHIFT', action = wezterm.action.ToggleFullScreen },
--     -- workaround to get Ctrl-/ to work if using tmux
--     -- or when term isn't recognizing in general
--     -- paired with comment keymap that is defined using "_" instead of "/"
--     -- { key = '/', mods = 'CTRL', action = wezterm.action({ SendString = '\x1f' }) },
-- }

-- plugins
-- I think because I have `$XDG_RUNTIME_DIR` set, my plugins are in ~/.local/share/wezterm/plugins
-- otherwise check `/run/user/1000/wezterm/plugins/`
-- only http or local filesystem repos are allowed
local wezterm_config_nvim = wezterm.plugin.require('https://github.com/winter-again/wezterm-config.nvim')
-- local wezterm_config_nvim = require('wezterm_config_plug')
-- local wezterm_config_nvim = wezterm.plugin.require('/home/andrew/Documents/code/nvim-dev/wezterm-config.nvim')
wezterm.plugin.update_all() -- keymap to reload/refresh config with this line here will update the plugin; otherwise it seems to check on nearly every action in wezterm

-- callbacks
wezterm.on('user-var-changed', function(window, pane, name, value)
    -- get copy of the currently set overrides if they exist
    -- otherwise empty table
    local overrides = window:get_config_overrides() or {}
    -- START of where user would use wezterm plugin API
    overrides = wezterm_config_nvim.override_user_var(overrides, name, value)
    -- utils.log_overrides(value, overrides)
    -- END
    window:set_config_overrides(overrides)
end)

wezterm.on('send-txt-to-pane', function(window, pane, name, value)
    -- this works
    local msg = 'Hi, mom. This is a custom message.'
    utils.send_text(pane, msg)
end)

wezterm.on('clear-overrides', function(window, pane)
    window:set_config_overrides({})
    window:toast_notification('wezterm', 'config overrides cleared', nil, 2000)
end)

return config
