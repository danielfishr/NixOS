-- Use each connected display's preferred mode with a consistent fractional scale.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1.5,
})

hl.config({
  general = {
    gaps_in = 3,
    border_size = 2,
  },
})
