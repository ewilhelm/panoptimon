# About

The email plugin allows you to collect one or more metrics (matched via
regexps) and relay them via mail on a configured interval.

# Config

```json
{
  "match" : ["^daemon_health", "^cpu"],
  "interval" : 3600,  # 5MB / day inbox!
  "unflatten" : true, # like compression, but ...

  "to"   : "required",
  "from" :  "you@host", # default ENV['USER'] + /etc/hostname
  "smtp_settings" : {
    # see Net::SMTP / ala ActionMailer
    #   address, port, domain, # aka 'helo'
    #   user_name, password, authentication # = plain|login|cram_md5
  }
}
```

# Regexp Matching

The elements of the 'match' list are going to be interpolated
into regular expressions, but quoted in JSON.  Thus, you will need to
write "^cpu\\|user" to specifically match the 'cpu|user' metric.  (Hint:
you may find the  "dot" any-character match e.g. "^cpu.user" to be more
readable and unambiguous enough for most cases.)
