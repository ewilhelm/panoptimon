# Configuration

```json
{
  "hosts" : [
    "localhost",
    {"name" : "example", "host": "ssh.example.com",
      "port": 17, "timeout": 7},
  ],
  "default_port"    : 22,
  "default_timeout" : 3,

  "interval" : 60,
  "timeout"  : 25,
}
```

# Output

```json
{
  "ssh|localhost|ok" : true, # whether connected or not
  "ssh|localhost|_info" : {"banner" : "SSH-2.0-OpenSSH_5.9p1 Debian-5ubuntu1"},
  "ssh|example|ok" : true,
  ...
}
```
