# Description

Reports on running / flapping services under various service management
daemons.

# Config

The `services` hash must contain entries for whichever service
management daemons you wish to monitor.

## Options

* `interval` — report interval, in seconds
* `flaptime` — flap threshold, in seconds
* `since` — flap horizon, in seconds
* `faults` — (experimental) report fault statistics [true|false|"only"]

## Available Daemons

### daemontools

Supported arguments:

* `-monitor` — an array of globs for service identifiers
* `-options` — a hash of options
    * `svstat` — path to svstat command (or as array with arguments)

All other keys are taken as the name of services to report on.  By
default, these are found under `/service/$name`, but an optional `path`
entry in the argument's hash can be used to alias service names.

    `"shortname": {"path" : "/service/name-too-long-for-daily-use"}`

You must provide either an explicit list of services or some globs in
'-monitor' (or else nothing is monitored.)

### smf

Supported arguments:

* `-monitor` — an array of globs for service identifiers
* `-options` — a hash of options
    * `svcs` — path to svcs command (or as array with arguments)

The globs given in `-monitor` are passed to `svcs` and must match the
service FMRI.

## Example

```json
{
  "interval": 60,
  "flaptime": 30,
  "since": 900,
  "faults" : false,
  "services": {
    "daemontools": {
      "-monitor" : ["/service/*"], "#": "probably all you need",
      "-options" : { "svstat" : [...] },
      "chef-client" : { },
      "syslog-ng" : {
        "path" : "/service/syslog-ng", "#": "is the default" },
    },
    "smf": {
      "-monitor" : ["*"], "#": "very noisy",
      "-options" : {"svcs" : ["sudo", "svcs"]},
    },
    "init":    { "foo" : { "status_cmd" : "..."} }, # TODO
    "systemd": { "sshd" : {...} } # TODO
  }
}
```

# Output

* up: seconds the service has been up (negative if it has been shutdown)
* flaps: number of flaps (runs under 'flaptime') within the 'since' horizon

```none
    services|daemontools|syslog-ng|up => $seconds
    services|daemontools|syslog-ng|flaps => $n
```
