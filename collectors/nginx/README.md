Description
===========

The Panoptimon collector nginx is intended to retrieve statistics from a running nginx instance. In order to leverage the collector you will need to have HTTPStubStatus module enabled. For further information on how to enable this module see below.

Usage
=====

The collector accepts JSON as input and expects to be provided with a URL. If a URL is not provided the collector will default to localhost.

```
nginx '{"url": "http://localhost/nginx-status"
```

Output will be returned as JSON.

```
{"requests":"137","writing":"1","total":"1","reading":"0"}
```


Module
=======
In order to for nginx to provide the information the collector requires we must first enable HTTPStubStatus. Within a server definition simply add the following.

```
location /nginx_status {
	stub_status on;
	access_log   off;
	allow 127.0.0.1;
	deny all;
}
```
