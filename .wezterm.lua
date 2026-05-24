local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.send_composed_key_when_left_alt_is_pressed = true

-- Get the hostname to conditionally apply configs
local hostname = ""
local handle = io.popen("hostname")
if handle then
	hostname = handle:read("*a"):gsub("%s+", "")
	handle:close()
end

-- For my personal MacBook
if false and string.find(hostname, ".local") then
	config.font = wezterm.font("Monaspace Krypton")
	config.font_rules = { {
		italic = true,
		font = wezterm.font("Monaspace Radon"),
	} }
end

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

config.color_scheme = "melange"

config.disable_default_key_bindings = true

config.keys = {
	{ key = "P", mods = "CTRL", action = wezterm.action.ActivateCommandPalette },
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
	{ key = "c", mods = "SUPER", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "SUPER", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
	{ key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "r", mods = "CMD", action = wezterm.action.ReloadConfiguration },
}

return config
