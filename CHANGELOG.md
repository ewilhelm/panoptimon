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
