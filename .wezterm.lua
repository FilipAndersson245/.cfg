-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()

--- Get the current operating system
--- @return "windows"| "linux" | "macos"
local function get_os()
    local bin_format = package.cpath:match("%p[\\|/]?%p(%a+)")
    if bin_format == "dll" then
        return "windows"
    elseif bin_format == "so" then
        return "linux"
    end

    return "macos"
end

local schema = wezterm.get_builtin_color_schemes()["Brogrammer"]
schema.background = "#050505"
schema.cursor_bg = "#f2f2f2"
schema.cursor_fg = "#f2f2f2"
schema.foreground = "#dde1eb"
config.color_schemes = {
    ["Brogrammer"] = schema
}

-- local font_features = {'calt', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09'}

config.font = wezterm.font("Monaspace Argon", {
    weight = "Regular",
    stretch = "Normal",
    style = "Normal",
    harfbuzz_features = font_features
})

config.font_rules = {{
    intensity = 'Bold',
    italic = true,
    font = wezterm.font("Monaspace Argon", {
        weight = "DemiBold",
        stretch = "Normal",
        style = "Italic"
    })
}, {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font("Monaspace Argon", {
        weight = "DemiBold",
        stretch = "Normal",
        style = "Normal"
    })
}, {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font("Monaspace Argon", {
        weight = "Regular",
        stretch = "Normal",
        style = "Italic"
    })
}, {
    intensity = 'Half',
    italic = true,
    font = wezterm.font("Monaspace Argon", {
        weight = "Light",
        stretch = "Normal",
        style = "Italic"
    })
}, {
    intensity = 'Half',
    italic = false,
    font = wezterm.font("Monaspace Argon", {
        weight = "Light",
        stretch = "Normal",
        style = "Normal"
    })
}}

config.font_size = 12
config.default_cursor_style = "BlinkingUnderline"
config.cursor_thickness = "2px"
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"

config.initial_rows = 45
config.initial_cols = 180
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.max_fps = 144
config.animation_fps = 18

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

config.color_scheme = "Brogrammer"

function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    local pane_title = tab_info.active_pane.title
    return pane_title and pane_title:gsub("%.exe$", "")
end

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#333333'
    local background = '#2e608c'
    local foreground = '#d9d9d9'

    if tab.is_active then
        background = '#0781df'
        foreground = '#ffffff'
    elseif hover then
        background = '#3b3052'
        foreground = '#909090'
    end
    local edge_foreground = background
    local title = tab_title(tab)
    title = wezterm.truncate_right(title, max_width - 2)

    return {{
        Background = {
            Color = edge_background
        }
    }, {
        Foreground = {
            Color = edge_foreground
        }
    }, {
        Text = " " .. SOLID_LEFT_ARROW
    }, {
        Background = {
            Color = background
        }
    }, {
        Foreground = {
            Color = foreground
        }
    }, {
        Text = title
    }, {
        Background = {
            Color = edge_background
        }
    }, {
        Foreground = {
            Color = edge_foreground
        }
    }, {
        Text = SOLID_RIGHT_ARROW
    }}
end)

config.window_padding = {
    left = 6,
    right = 4,
    top = 6,
    bottom = 4
}
-- config.enable_scroll_bar = true

-- Keybindings
config.keys = {{
    key = "v",
    mods = "CTRL",
    action = wezterm.action({
        PasteFrom = "Clipboard"
    })
}}

-- Default Shell Configuration
config.default_prog = {"pwsh", "-NoLogo"}

return config

