# Description

Reports on zfs pool size and health.

# Output

The metrics `used`, `free`, `state`, and `faults` will always be
present.  If there are faults, the `errors` hash may contain additional
metrics.  The error metrics `read`, `write`, and `cksum` are as-reported
for the zfs pool (see `zpool status`.)

Note that `faults` may be non-zero while the pool is still fully
functional (and `state=1`) if there are minor errors on a device,
including data loss.  The device-specific errors are reported under
`_info`.  Unrecoverable (pool) errors will appear as `read`, `write`, or
`cksum` at the upper level.  The value of `faults` is a count of all
vdevs which contain errors (including the pool itself), so a flaky
(redundant) disk in a mirror would appear as `faults=2`, but with 2/2
corrupted: faults = 2 (disks) + 1 (mirror) + 1 (pool) = 4.

```yaml
zpool:
  monkey:
    used:  39.2   # GB
    free:  17.483 # GB
    state: 10 # 10=ONLINE 5=DEGRADED, 0=FAULTED/UNAVAIL
    faults: 4
    errors:
      read: 8
      _info:
        c1t1d0: { state: "ONLINE", errors: {read: 2}}
        c2t5d0: { state: "ONLINE", errors: {read: 6}}
        files: ["<0x0>", "a.txt"]
```
