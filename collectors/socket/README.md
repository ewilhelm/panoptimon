### Description

Connect to arbitrary TCP & UNIX sockets and match output. Input is expected to be an Array of TCP & UNIX checks as the following describes.


``` json
{
  "checks": {
    "haproxy": {
      "path": "/var/run/haproxy/stats",
      "timeout": 10,
      "query": "show info",
      "match": ".*"
    },
    "cloudysunday": {
      "path": "localhost",
      "port": 22,
      "timeout": 5,
      "match": "SSH"
    }
  }
}
```

### Check Attributes

**Path:** Describes the endpoint of a given socket.  This will
automatically determine the type (TCP vs Unix) of check.

**Timeout:** Number of seconds to connect/query a given socket and return.

**Match:** Parse the output ensuring it includes the given match string.

**Query (Unix Only):** Input to a given a socket.

**Port (TCP Only):** Port to connect to (default: 80).
