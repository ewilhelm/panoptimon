# Usage

The '/metrics.json' request path will return a json object representing
the current state of the metrics (TODO: maybe If-Modified-Since
support.)

To request only specific groups of metrics, append one or more metric
names separated by '&'.  Metric names must match up to a '|' or the end.


```none
  $ GET 'http://localhost:8080/metrics.json'
  { ... } # everything

  $ GET 'http://localhost:8080/metrics.json/cpu'
  {"cpu|user":"3","cpu|system":"2","cpu|idle":"95","cpu|wait":"0"}

  $ GET 'http://localhost:8080/metrics.json/cpu|user'
  {"cpu|user":"2"}

  $ GET 'http://localhost:8080/metrics.json/iostat|sda|util&disk|/dev/sda3|space_free&disk|/dev/sda3|files_free'
  {"disk|/dev/sda3|space_free":3.628937,"disk|/dev/sda3|files_free":336963,"iostat|sda|util":0.0}
```
