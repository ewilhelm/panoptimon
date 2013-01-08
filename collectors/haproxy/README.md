# Description

This collector provides a check on all defined resources within HAProxy. 

# Configuration

The `stats_url` can point at either the http: or socket: protocol
(socket is assumed if the protocol is missing.)  Note that socket usage
requires appropriate ownership/group permissions.

```json
{
  "stats_url": "socket://var/run/haproxy/stats"
  # or http://localhost:8080
}
```

# Output

```json
{
  "uptime_sec"      : ...,
  "status|up"       : 13,
  "status|down"     : 1,
  "status|open"     : 6,
  "status|no_check" : 4,
  "process_num"     : 1,
  "pid"             : 3720,
  "nbproc"          : 3,
  "run_queue"       : 1,
  "tasks"           : 17,
  "_info" : {
    "version" : "1.4.22",
    "status" : {
      "FRONTEND" : {"x" : "open", "y" : "open", ...},
      "BACKEND" : {"x" : "up", "y" : "down", ...
    },
  },
}
```
