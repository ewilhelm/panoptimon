Returns information about a process, or set of processes.

Can look simply for a process name, or match against an expression, search for all processes owned by a user... can also match processes that match certain characteristics as defined in the optional arguments section.

  ps -wwo 'pid,time,etime,nwlp,pcpu,ni,pri,vsz,rss,command' \
    -p $(pgrep -d, sshd)

# Config

The "checks" hash contains a list of check names, plus info for invoking pgrep.

```json
{
  interval: 60,
  checks: {
    sshd: {
      pattern: "^sshd", # also 'full:  "^/usr/sbin/sshd( |$)"
      user: "root,daemon"
    },
    "sshd and kids" : { "pattern" : "^sshd" },
    openvpn: { full: "^/usr/sbin/openvpn" },
    alsovpn: { full: "^/usr/local/sbin/openvpn" },
  }
}
```

## Matching

Each check must have one or more of the following for pgrep(1).

* a `user` key with a username

* a `pattern` or `full` key with a regexp -- `full` matches on the whole command line, where `pattern` only matches the process (base)name.  Start with the '^' anchor (unless you mean otherwise), but beware ending a `full` pattern with '$' (try ' ' or '( |$)' instead.)

# Returns:

Information about each matched process, plus a count.

  process|ssh|count => 1
  process|ssh|0|time => 400
  process|ssh|0|etime => 6000
  process|ssh|0|pid => 3750
  process|ssh|0|pcpu => 0.2
  process|ssh|0|nwlp => 1
  process|ssh|0|rss => ...
  process|ssh|0|nice => ...
  process|ssh|0|priority => ...
  process|ssh|_info => { 'command' => [...] }

Each process matched by a check will have a metric index (starting at zero.)

For each matched process in a set, the full command and arguments will
be indexed under the _info.command array.

Multiple checks could match the same process, in which case its metrics will be repeated under each check name.

If a check matches no processes, only the `count = 0` metric is present.
