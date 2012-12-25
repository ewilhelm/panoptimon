
# Permissions

Your ping binary must be `setcap cap_net_raw=ep` or setuid root.  The
collector itself requires no special permissions.

# Config

```json
  {
    "hosts" : [
      "example.com",
      # or with per-host settings
      {"host" : "localhost", "timeout" : 1, "count" : 1}
    ],

    # defaults
    "default_timeout" : 4,
    "default_count"   : 2,
    "ping"            : "/bin/ping", # defaults to search $PATH

    # standard collector configuration
    "interval" : ...
    "timeout" : ...
    "exec" : "ping/ping",
    "args" : [],
  }
```

# Output

{
   "ping|example.com|loss"     : 0,    # 0-1 float
   "ping|example.com|rtt_avg"  : 54.47,
   "ping|example.com|rtt_max"  : 55.914,
   "ping|example.com|rtt_min"  : 53.027,
   "ping|example.com|rtt_mdev" : 1.462,
   "ping|example.com|rx"       : 8, # received
   "ping|example.com|tx"       : 8, # transmitted
   "ping|example.com|_info"    : { "resolved" : "192.0.43.10" }
}


# Errors

{
   "ping|whatever.example.com|error" : 2, # return code
   "ping|whatever.example.com|_info" : {
      "error" : "ping: unknown host whatever.example.com"
   },
   "ping|whatever.example.com|loss" : 1,
   "ping|whatever.example.com|rx"   : 0,
   "ping|whatever.example.com|tx"   : 0
}
