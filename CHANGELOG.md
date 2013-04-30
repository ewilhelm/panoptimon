# 0.2.0

Removed the mysql_status collector from core to reduce gem dependencies.
It can now be found at https://github.com/synthesist/panoptimon-collector-mysql_status

# 0.1.0

Added functionality to search for executables in the PATH environment variable directories.
If there a collector named 'thing.json', if it cannot find the 'thing' executable locally
it will search PATH for 'pancollect-thing'.
