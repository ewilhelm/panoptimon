# Config

Each item in the 'collect' hash becomes the name of a collector output.
The value can be simply a URL, or a hash ("url" entry required) with
additional options.

```json
{
  "collect" : {
    "zebra" : "http://zebracage.localnet.zoo/status.json",
    "monkey" : { "url" : "http://monkeycage.localnet.zoo/status.json" }
  },
  "default_timeout" : 3,

}
```

# Output

Each collector name is reported as a toplevel name, along with the
collected hash -- as retrieved.  If there is a timeout (on connect or
get), the value of the 'timeout' metric will be true.

```json
{ "_name" : "zebra", "temp" : 20, "rh" : 85, ... }
{ "_name" : "monkey", "missing" : true, "last_seen" : 270 }
```
