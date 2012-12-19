# Config

The 'hosts' section is a hash of hostnames and record types to be
queried.  Valid types include 'a', 'mx', 'ns', 'ptr', 'txt', 'cname',
and 'any'.  Query result types may vary from the request.

```json

{
  "hosts" : {
    "example.com" : ["a", "mx", "ns"],
    "www.example.com" : ["cname"],
  },
  "nameservers" : [null, "ns.example.com"]
}
```

# Results

The results will include a count (`n`) and _info.records for each.

```json
{
   "dns|ns.example.com|www.example.com|cname|n" : 1,
   "dns|default|www.example.com|cname|n" : 1,
   "dns|ns.example.com|www.example.com|cname|_info" : {
      "records" : [ "see-also.example.com.  ]
   },
   "dns|default|www.example.com|cname|_info" : {
      "records" : [ "see-also.example.com.  ]
   }
}
```
