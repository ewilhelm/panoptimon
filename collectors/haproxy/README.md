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

