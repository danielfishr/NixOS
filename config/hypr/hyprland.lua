local mainMod = "SUPER"
local terminal = "kitty"
local menu = "fuzzel"
local fileManager = "nautilus"

hl.on("hyprland.start", function()
  hl.exec_cmd("mako")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")

hl.config({
  input = {
    kb_layout = "gb",
    follow_mouse = 1,
    touchpad = {
      natural_scroll = false,
      tap_to_click = true,
    },
  },
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 4,
    col = {
      active_border = "rgba(fab387ff)",
      inactive_border = "rgba(45475aff)",
    },
    layout = "dwindle",
    resize_on_border = true,
  },
  decoration = {
    rounding = 8,
    active_opacity = 1.0,
    inactive_opacity = 0.96,
    blur = {
      enabled = false,
    },
    shadow = {
      enabled = true,
      range = 8,
      render_power = 3,
      color = 0x55000000,
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    preserve_split = true,
  },
  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
  },
})

hl.curve("easeOut", {
  type = "bezier",
  points = { { 0.16, 1 }, { 0.3, 1 } },
})
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "easeOut" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "easeOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOut", style = "slide" })

-- Shortcut reference
--
-- Applications and windows:
--   Super+Return             Open Kitty
--   Super+D                  Open the application launcher
--   Super+E                  Open the file manager
--   Super+O                  Focus the previously selected window
--   Super+X                  Close the active window
--   Super+Shift+E            Exit Hyprland
--   Super+F                  Toggle fullscreen
--   Super+V                  Toggle floating mode
--   Super+P                  Toggle pseudotiling
--   Super+Shift+J            Toggle the split direction
--
-- Focus and workspaces:
--   Super+Arrow / Super+HJKL Move focus
--   Super+0..9               Switch workspace (0 selects workspace 10)
--   Super+Shift+0..9         Move the active window to a workspace
--   Super+mouse wheel        Cycle workspaces
--   Super+left drag          Move a window
--   Super+right drag         Resize a window
--
-- Screenshots:
--   Print                    Select an area and copy it to the clipboard
--   Super+Print              Copy the entire screen to the clipboard
--
-- Hardware keys control volume, playback and display brightness.
-- Super+Q is deliberately left unbound.

-- Applications and session controls.
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + O", hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit"))

-- Move focus with arrows or Vim keys.
local focusKeys = {
  left = "left",
  right = "right",
  up = "up",
  down = "down",
  H = "left",
  L = "right",
  K = "up",
  J = "down",
}

for key, direction in pairs(focusKeys) do
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
end

-- Switch workspaces and move the active window between them.
for workspace = 1, 9 do
  local key = tostring(workspace)
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Cycle workspaces and move/resize windows with the mouse.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots are copied to the clipboard.
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim - | wl-copy"))

-- Media, volume and brightness keys.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
