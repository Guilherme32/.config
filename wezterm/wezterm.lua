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
        key = 'UpArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'DownArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Down',
    },
    {
        key = 'RightArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'LeftArrow',
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
        key = "LeftArrow",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Left", 5 }
    },
    {
        key = "RightArrow",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Right", 5 }
    },
    {
        key = "UpArrow",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Up", 5 }
    },
    {
        key = "DownArrow",
        mods = "ALT|CTRL",
        action = act.AdjustPaneSize { "Down", 5 }
    },
    -- Others ---------------------------------------------------------------
    {
        key = "v",
        mods = "CTRL|SHIFT",
        action = act.PasteFrom "Clipboard",
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
            bg_color = "fb4934",
            fg_color = "fb4934",
        },
        inactive_tab = {
            bg_color = "#001900",
            fg_color = "#304935",
        },
        inactive_tab_hover = {
            bg_color = "#cc241d",
            fg_color = "#cc241d",
        },
        new_tab = {
            bg_color = "#001900",
            fg_color = "#504945",
        },
        new_tab_hover = {
            bg_color = "#cc241d",
            fg_color = "#cc241d",
            italic = false,
        }
    }
}

return {
    keys                         = _keys,
    font                         = wezterm.font("FantasqueSansM Nerd Font", {
        -- weight = "Bold", --italic = true,
    }),
    font_size                    = 13,
    text_background_opacity      = 0.5,
    window_background_opacity    = 0.9,
    initial_cols                 = 120,
    initial_rows                 = 45,
    color_scheme                 = "GruvboxDarkHard", --"Fahrenheit",-- "FunForrest",  --"Twilight",
    hide_tab_bar_if_only_one_tab = true,
    tab_max_width                = 2,
    use_fancy_tab_bar            = false,
    colors                       = _colors,
    default_prog                 = { 'fish', '-l' },
    window_decorations           = "TITLE | RESIZE",
    -- freetype_load_target         = "Mono"
}
