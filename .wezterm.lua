local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.send_composed_key_when_left_alt_is_pressed = true
config.enable_kitty_keyboard = true
config.color_scheme = "melange"
config.skip_close_confirmation_for_processes_named = {}

config.font_size = 14
config.line_height = 1.1
config.harfbuzz_features = {
	"calt",
	"ss01",
	"ss02",
	"ss03",
	"ss04",
	"ss05",
	"ss06",
	"ss07",
	"ss08",
	"ss09",
	"liga",
	"cv03", -- g
	"cv04", -- j
	"cv14", -- $
	"cv15", -- &
	"cv16", -- Q
}

config.disable_default_key_bindings = true
config.keys = {
	{ key = "p", mods = "CMD", action = wezterm.action.ActivateCommandPalette },
	{ key = "l", mods = "CMD", action = wezterm.action.ShowDebugOverlay },
	{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
	{ key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
	{ key = "+", mods = "CMD", action = wezterm.action.IncreaseFontSize },
	{ key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },
	{ key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "r", mods = "CMD", action = wezterm.action.ReloadConfiguration },
	{ key = "n", mods = "CMD", action = wezterm.action.SpawnWindow },
}

return config
