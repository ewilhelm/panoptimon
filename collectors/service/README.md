upstart: `initctl list`

```none
qemu-kvm start/running
rc stop/waiting
rsyslog start/running, process 1237
network-interface (lo) start/running
```

daemontools: `svstat /service/\*` (aside: `ps -eo %a | grep '[s]vscan ' | cut -d' ' -f2 | sort -u`)

```none

/service/chef-client: up (pid 14971) 1197 seconds
/service/hubot: up (pid 6583) 8895 seconds
/service/resmon: up (pid 633) 4131042 seconds
/service/syslog-ng: up (pid 632) 4131042 seconds
/service/mail-in:  down 3 seconds, normally up
```

systemd: `systemctl list-units --full --type=service --all`, `systemctl show NAME NAME NAME ...`

## Config

```json
{
  services: {
    init: { foo : { status_cmd : "..."} },
    systemd: {
      sshd : {...}
    },
    daemontools: {
      "-monitor" : ["/service/*"], # probably all you need
      "-options" : { "svstat" : ["..."] },
      "chef-client" : { },
      "syslog-ng" : {"path" : "/service/syslog-ng"}, # is the default
    }
  }
}
```
