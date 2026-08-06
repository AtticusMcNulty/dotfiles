-- -----------------------------------------------------------------------------
-- Configures the WezTerm terminal emulator. This sets the theme, font, window
-- appearance, and behavior, and dims unfocused windows so it's easier to tell
-- which terminal is currently active.
-- -----------------------------------------------------------------------------

local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Configures the terminal's appearance and behavior.
config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

-- Settings applied to windows that aren't currently focused.
local UNFOCUSED_FOREGROUND_TEXT_HSB = {
  hue = 1.0,
  saturation = 0.25,
  brightness = 0.45,
}
local UNFOCUSED_WINDOW_BACKGROUND_OPACITY = 0.62

-- Compares two foreground text color values.
--
-- get_config_overrides() returns a new table each time it's called, so we
-- compare the values inside the tables instead of comparing the tables
-- themselves.
local function same_text_hsb(actual, expected)
  if actual == nil or expected == nil then
    return actual == expected
  end

  return actual.hue == expected.hue
    and actual.saturation == expected.saturation
    and actual.brightness == expected.brightness
end

-- Updates the appearance whenever a window gains or loses focus.
wezterm.on("window-focus-changed", function(window)
  local overrides = window:get_config_overrides() or {}

  local text_hsb, opacity

  if not window:is_focused() then
    text_hsb = UNFOCUSED_FOREGROUND_TEXT_HSB
    opacity = UNFOCUSED_WINDOW_BACKGROUND_OPACITY
  end

  -- Only update the configuration if one of the values we manage changed.
  -- This avoids triggering unnecessary configuration reloads.
  if same_text_hsb(overrides.foreground_text_hsb, text_hsb)
    and overrides.window_background_opacity == opacity then
    return
  end

  overrides.foreground_text_hsb = text_hsb
  overrides.window_background_opacity = opacity

  window:set_config_overrides(overrides)
end)

return config