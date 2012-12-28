### Description

HAProxy provides a plethora of information via the statistics socket. The intent of this collector is to provide a check on all defined resources within HAProxy. 

### Requirements

* HAProxy
* HAProxy statistics socket enabled
* Ruby
* RubyGems

### Configuration

Currently only defining a socket is supported and is defined within the collector's JSON configuration file. 

```
{
  "socket": "/var/run/haproxy/stats"
}
```

### Output

A JSON data structure is returned indication the status of your resources, if any resources are reported to be down a status code of "1" is returned. In addition several attributes assocated with your HAProxy installation are returned, including.

* PID
* Version
* Uptime
* Processes
* Nbproc
