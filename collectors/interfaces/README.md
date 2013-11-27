# Description

Reports 'rx packets', 'tx packets', and similar metrics per-interface.

# Portability

On linux hosts, reads `/proc/net/dev` and reports those metrics.  For
others, parses output of `netstat -i` and reports fewer metrics.
