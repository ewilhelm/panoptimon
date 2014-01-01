# Description

Reports on running / flapping services under various service management
daemons.

# Config

```json
{
  interval: 60
  flaptime: 30,
  since: 900,
  services: {
    init: { foo : { status_cmd : "..."} },
    systemd: {
      sshd : {...}
    },
    daemontools: {
      "-monitor" : ["/service/*"], # probably all you need
      "-options" : { "svstat" : ["..."] },
      "chef-client" : { },
      "syslog-ng" : {"path" : "/service/syslog-ng"}, # is the default
    }
  }
}
```

# Output

* up: seconds the service has been up (negative if it has been shutdown)
* flaps: number of flaps (runs under 'flaptime') within the 'since' horizon

  services|daemontools|syslog-ng|up => $seconds
  services|daemontools|syslog-ng|flaps => $n
