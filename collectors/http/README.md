# Config

The list of urls may include simple urls (http:// is assumed if the
scheme is omitted), or hashes for more specific behavior.

* 'name' - a shorthand name for the report rather than the full url
* 'method' - 'get' or 'head'
* 'match' - regexp match against the content (implies the 'get' method)
* 'timeout' - timeout

```json
{
  "urls" : [
    "localhost",
    "example.com",
    "https://github.com",
    {"name" : "example", "url": "https://ssl.example.com:6983/whatever",
      "match" : "<title>What", "timeout": 7},
  ],
  "default_method" : "head",
  "default_timeout" : 3,

  "interval" : 60,
  "timeout"  : 25,
}
```

# Output

Output will typically contain the following, depending on the status and
request.  If the request timed-out, the 'timeout' metric will be true.

```json
{
  "http|localhost|code"    => 200,
  "http|localhost|elapsed"        => 0.02, # seconds
  "http|localhost|content_length" => 97,   # bytes
  ...
  "http|github.com|ssl|expires_in" => 604809, # seconds
  "http|github.com|ssl|_info" => {
    "issuer" : "Digicert Inc",
    "serial"  : "...",
    "valid"   : "2010-06-19 00:00:00 UTC",
    "expires" : "2011-06-19 00:00:00 UTC"
  }
  ...
  "http|example|ok"        => true, # only if there is a match spec'd
}
```
