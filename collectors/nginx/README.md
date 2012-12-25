#Description

The Panoptimon collector 'nginx' is intended to retrieve statistics from a
running nginx instance. The nginx module 'HTTPStubStatus' is required (see
below.)

# Config

```json
 {"url": "http://localhost/nginx-status"}
```

# Output

```
{"requests":"137","writing":"1","total":"1","reading":"0"}
```


# Requisite Server Setup

The nginx server must provide the information via its HTTPStubStatus
module. Within a server definition simply add the following.

```
location /nginx-status {
	stub_status on;
	access_log   off;
	allow 127.0.0.1;
	deny all;
}
```
