# 0.4.17

* collectors/memory - portability: parsing solaris kstat

# 0.4.16

* hangup - disable distant signal traps/ignores

# 0.4.15

* collectors/iostat - compat for older (v9.x) sysstat

# 0.4.14

* collectors/iostat - portability: parsing solaris output

# 0.4.13

* collectors/load - portability: parsing `uptime`

# 0.4.12

* collectors/files - `relativized_mtime` option to report `last_modified`

# 0.4.11

* collectors/interfaces - portability: parsing netstat for data

# 0.4.10

* collectors/process - portability, rename ni -> nice, skip thcount
  except on linux

# 0.4.9

* collectors/cpu - portable vmstat, skip wait if missing

# 0.4.8

* collectors/process - include pid metric, fix spuriously reporting self

# 0.4.1

* collectors/rabbitmq - add RabbitMQ collector

# 0.4.0

* collectors/disk - remove sys-filesystem dependency

# 0.3.0

* plugins/graphite/ - added
* collectors/iostat/ - allow missing headers
* `monitor.http.hostport()` logged on init
* `panoptimon --plugin-test` with .rb file

# 0.2.0

Removed the mysql_status collector from core to reduce gem dependencies.
It can now be found at https://github.com/synthesist/panoptimon-collector-mysql_status

# 0.1.0

Added functionality to search for executables in the PATH environment variable directories.
If there a collector named 'thing.json', if it cannot find the 'thing' executable locally
it will search PATH for 'pancollect-thing'.
