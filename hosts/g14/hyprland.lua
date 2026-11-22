-- Use each connected display's preferred mode with native 1x scaling.
hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor Adwaita 24")
end)

-- Launch HyprEmoji with Hyper+period.
hl.bind("CTRL + SHIFT + ALT + SUPER + period", hl.dsp.exec_cmd("hypremoji"))
hl.window_rule({
  match = { title = "^(HyprEmoji)$" },
  float = true,
  move = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.05)" },
})

-- Super+C (correct): copy the selected word and offer British English suggestions.
hl.bind("SUPER + C", hl.dsp.exec_cmd("spelling-suggestions"), { release = true })

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
