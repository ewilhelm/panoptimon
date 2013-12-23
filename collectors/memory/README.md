# Description

Reports memory and swap statistics (in GB.)

# Portability

On linux, reads from /proc/meminfo.  On solaris, reads kstat output
(swap statistics are average-since-boot until the second interval
because the values of kstat's `vminfo` are accumulated counters.)
