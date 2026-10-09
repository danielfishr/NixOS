-- Use each connected display's preferred mode and automatic scale.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

hl.config({
  general = {
    gaps_in = 3,
    border_size = 2,
  },
})
