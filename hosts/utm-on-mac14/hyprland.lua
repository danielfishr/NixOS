-- UTM display sized for the 14-inch Apple Silicon MacBook Pro panel.
hl.monitor({
  output = "Virtual-1",
  mode = "3024x1964@60",
  position = "auto",
  scale = 2,
})

-- UTM exposes a ghost second output that would pin workspace 2 to an invisible
-- monitor, so disable it to keep Super+number workspace switching on Virtual-1.
hl.monitor({
  output = "Unknown-1",
  disabled = true,
})
