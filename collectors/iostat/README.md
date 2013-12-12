# Description

Reports average disk statistics over the configured `interval`.

Omits the first output of `iostat`, which contains all-time average
(since boot.)  This causes a delay in the first report.  This collector
is persistent.

# Portability

On solaris, uses `iostat -xne`, Linux uses `iostat -xd`.  The available
metrics vary.
