# Description

Reports average load for the past 1, 5, and 15 minutes.

# Portability

On linux hosts, reads '/proc/loadavg and reports extra jobs data.
Elsewhere, runs `uptime`.
