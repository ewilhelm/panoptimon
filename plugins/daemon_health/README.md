# Daemon Health Plugin (Self-Happiness Metrics Collector)

This plugin will periodically add metrics to the bus, while also
listening to other metrics to generate statics about the collected data.

# Configuration

`periods = ["60m", 300, 30]` - an array of reporting periods (in
seconds, or minutes with 'm' suffix)

`interval = 30` - the reporting interval (and rollup granularity) in
seconds.  The periods should all be a multiple of this for consistent
results.


```json
  {
   "daemon_health|300|metrics|nps"  : 4.5867, # 5m moving avg
   "daemon_health|900|metrics|nps"  : 5.3778, # 15m ...
   "daemon_health|3600|metrics|nps" : 5.4373, # 1hr...
   "daemon_health|collectors"       : 8,
   "daemon_health|loaded_plugins"   : 5,
   "daemon_health|active_plugins"   : 3,      # with callbacks
   "daemon_health|uptime"           : 960,    # seconds
   "daemon_health|rss"              : 21784,  # kB
  }
```

Moving averages are calculated within the configured window (unless the
uptime is less than the window, in which case it is the average over
uptime.)
