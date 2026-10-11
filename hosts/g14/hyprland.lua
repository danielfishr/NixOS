-- Use each connected display's preferred mode with native 1x scaling.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.config({
  general = {
    gaps_in = 3,
    border_size = 2,
  },
})
