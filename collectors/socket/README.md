### Description

Connect to arbitrary TCP & UNIX sockets and match output. Input is expected to be an Array of TCP & UNIX checks as the following describes.


``` json
{
  "checks": {
    "haproxy": {
      "path": "/var/run/haproxy/stats",
      "timeout": "10",
      "query": "show info",
      "match": ".*"
    },
    "cloudysunday": {
      "path": "cloudysunday.com",
      "port": "22",
      "timeout": "5",
      "match": "SSH"
    }
  }
}
```

A check consists of a unique name and a number of attributes. Attributes differ between TCP & UNIX sockets, where TCP supports:

* Path
* Timeout
* Match
* Port


Unix supports:

* Path
* Timeout
* Match
* Query

### Check Attributes


**Path:** Describes the endpoint of a given socket.

**Timeout:** Number of seconds to connect/query a given socket and return.

**Match:** Parse the output ensuring it includes the given match string.

**Query (TCP Only):** Input to a given a socket.

**Port (TCP Only):** Port to connect to (default: 80).
