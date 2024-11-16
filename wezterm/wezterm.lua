local wezterm = require "wezterm"
act = wezterm.action

_keys = {
    -- Tabs ------------------------------------------------------------------
    {
        key = 'e',
        mods = 'CTRL',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'LeftArrow',
        mods = 'CTRL',
        action = act.ActivateTabRelative(-1),
    },
    {
        key = 'RightArrow',
        mods = 'CTRL',
        action = act.ActivateTabRelative(1),
    },
    -- Panes -----------------------------------------------------------------
    {
        key = 'k',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'j',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Down',
    },
    {
        key = 'l',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'h',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = "p",
        mods = "CTRL",
        action = act.SplitVertical { domain = "CurrentPaneDomain" }
    },
    {
        key = "s",
        mods = "CTRL",
        action = act.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        key = "w",
        mods = "ALT",
        action = act.CloseCurrentPane { confirm = true }
    },
    {
        key = "h",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Left", 5 }
    },
    {
        key = "l",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Right", 5 }
    },
    {
        key = "k",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Up", 5 }
    },
    {
        key = "j",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Down", 5 }
    },
    {
        key = "e",
        mods = "ALT",
        action = act.TogglePaneZoomState
    },
    -- Others ---------------------------------------------------------------
    {
        key = "v",
        mods = "CTRL|SHIFT",
        action = act.PasteFrom "Clipboard",
    },
    {
        key = "m",
        mods = "ALT",
        action = act.ToggleFullScreen,
        -- action = act.CloseCurrentPane { confirm = true }
    },
    -- {
    --     key = "c",
    --     mods = "CTRL|SHIFT",
    --     action = act.CopyTo "Clipboard",
    -- },
}

_colors = {
    tab_bar = {
        background = "#002000",
        active_tab = {
            bg_color = "#fb4934",
            fg_color = "#001900",
        },
        inactive_tab = {
            bg_color = "#001900",
            fg_color = "#cf3f2e",
        },
        inactive_tab_hover = {
            bg_color = "#cc241d",
            fg_color = "#001900",
        },
        new_tab = {
            bg_color = "#001900",
            fg_color = "#cf3f2e",
        },
        new_tab_hover = {
            bg_color = "#cc241d",
            fg_color = "#001900",
            italic = false,
        }
    }
}

return {
    keys                         = _keys,
    font                         = wezterm.font("FantasqueSansM Nerd Font", {
        -- weight = "Bold", --italic = true,
    }),
    font_size                    = 11,
    text_background_opacity      = 0.5,
    window_background_opacity    = 0.9,
    initial_cols                 = 120,
    initial_rows                 = 64,
    color_scheme                 = "GruvboxDarkHard", --"Fahrenheit",-- "FunForrest",  --"Twilight",
    hide_tab_bar_if_only_one_tab = true,
    tab_max_width                = 2,
    use_fancy_tab_bar            = false,
    colors                       = _colors,
    default_prog                 = { 'fish', '-l' },
    window_decorations           = "TITLE | RESIZE",
    -- freetype_load_target         = "Mono"
}
