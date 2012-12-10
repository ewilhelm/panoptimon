Returns information about a process, or set of processes.

Can look simply for a process name, or match against an expression, search for all processed owned by a user... can also match processes that match certain characteristics as defined in the optional arguments section.

  ps -wwo 'pid,time,etime,thcount,pcpu,ni,pri,vsz,rss,command' \
    -p $(pgrep -d, sshd)

# Config

The "checks" hash contains a list of check names, plus info for invoking pgrep.

```json
{
  interval: 60,
  checks: {
    sshd: {
      pattern: "^sshd", # also 'full:  "^/usr/sbin/sshd"
      user: "root,daemon"
    }
  }
}
```

# Return:

Information about each matched process, plus a count.

  process|ssh|count => 1
  process|ssh|0|time => 400
  process|ssh|0|etime => 6000
  process|ssh|0|pcpu => 0.2
  process|ssh|0|thcount => 1
  process|ssh|0|rss => ...
  process|ssh|0|nice => ...
  process|ssh|0|priority => ...
  process|ssh|_info => { 'cmd' => [...] }
