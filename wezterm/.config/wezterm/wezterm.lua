local wezterm = require('wezterm')
local config = {}

-- trying this since it's technically using the dGPU now; unsure of whether one is clearly better
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[2]
-- config.front_end = 'WebGpu'
config.front_end = 'OpenGL'

config.default_prog = {'/usr/bin/zsh'}
config.default_cwd = wezterm.home_dir
-- config.scrollback_lines = 0

config.color_scheme = 'tokyonight_night' -- builtin colorscheme (Folke ver)
config.colors = {
    tab_bar = {
        active_tab = {
            bg_color = '#16161e',
            fg_color = '#c0caf5',
        },
        inactive_tab = {
            bg_color = '#1a1b26',
            fg_color = '#737aa2'
        },
        inactive_tab_hover = {
            bg_color = '#24283b',
            fg_color = '#c0caf5',
        },
        inactive_tab_edge = '#c0caf5',
        new_tab = {
            bg_color = '#16161e',
            fg_color = '#c0caf5'
        },
        new_tab_hover = {
            bg_color = '#24283b',
            fg_color = '#c0caf5'
        }
    }
}

config.font = wezterm.font 'Hack Nerd Font Mono'
config.freetype_load_flags = 'NO_HINTING' -- use this to keep curly braces {} nicely aligned
config.font_size = 12.0
config.window_frame = {
    font = wezterm.font 'Hack Nerd Font Mono',
    font_size = 10.0,
    active_titlebar_bg = '#1d202f', -- color of the space behind tabs
    inactive_titlebar_bg = '#1d202f',
}
-- background
config.background = {
    {
        source = {
            File = ''
        },
        -- vertical_offset = -300,
        opacity = 0.2,
    }
}
config.use_fancy_tab_bar = true -- default
config.show_tab_index_in_tab_bar = true
-- config.enable_tab_bar = false -- disable tab bar
config.hide_tab_bar_if_only_one_tab = true
config.cursor_blink_rate = 0 -- disable blinking
config.window_padding = {
    left = 2,
    right = 2,
    top = 10,
    bottom = 0
}
-- config.enable_scroll_bar = true
-- always spawn new tab in home dir w/ shortcut; however, doesn't get honored when clicking new tab button?
config.keys = {
    {key = 'N', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnCommandInNewTab {
        cwd = wezterm.home_dir
    }
    },
    {key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.ShowDebugOverlay},
    -- tab navigation
    {key = 'Q', mods = 'CTRL|SHIFT', action = wezterm.action{ActivateTab=0}},
    {key = 'W', mods = 'CTRL|SHIFT', action = wezterm.action{ActivateTab=1}},
    {key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action{ActivateTab=2}},
    {key = 'R', mods = 'CTRL|SHIFT', action = wezterm.action{ActivateTab=3}},
    -- tab navigation but cycling
    {key = '{', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1)},
    {key = '}', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(1)},
    -- create splits
    {key = '|', mods = 'CTRL|SHIFT', action = wezterm.action{SplitHorizontal = {domain = 'CurrentPaneDomain'}}},
    {key = '_', mods = 'CTRL|SHIFT', action = wezterm.action{SplitVertical = {domain = 'CurrentPaneDomain'}}},
    -- pane navigation rebinds
    {key = 'H', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left'},
    {key = 'J', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down'},
    {key = 'K', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up'},
    {key = 'L', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right'},
    -- resize panes
    {key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize{'Left', 2}},
    {key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize{'Right', 2}},
    {key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize{'Up', 2}},
    {key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize{'Down', 2}},
    {key = 'M', mods = 'CTRL|SHIFT', action = wezterm.action.ToggleFullScreen},
    -- workaround to get Ctrl-/ to work if using tmux
    -- or when term isn't recognizing in general
    -- paired with comment keymap that is defined using "_" instead of "/"
    {key="/", mods="CTRL", action=wezterm.action{SendString="\x1f"}}
}

-- maximize on startup
-- wezterm.on('gui-startup', function(cmd)
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():maximize()
-- end)

-- customize window title
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
    -- local index = ''
    -- if #tabs > 1 then
    --     index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    -- end
    -- return index
    return ''
end)

-- for the zen-mode.nvim plugin to interact with Wezterm
wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

return config
