-- Use each connected display's preferred mode with native 1x scaling.
hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor Adwaita 24")
end)

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.config({
  general = {
    gaps_in = 3,
    border_size = 4,
  },
})
