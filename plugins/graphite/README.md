# Graphite Plugin

This plugin emits metrics to Graphite.

# Supported Platforms

* Linux

# Configuration

### graphite.json example

````
{
  "host": "graphite.example.com",
  "port": 2003,
  "prefix": "env.location.foo"
}
````

## Host

The name or IP of your Graphite server

Default: localhost

## Port

The port carbon is listening on.

Default: 2003

## Prefix

The name to prefix to the path panoptimon streams to Graphite. For instance, if
you set `prefix` to `qa.san-jose.app1`, the full CPU idle path Graphite
receives will be:

`qa.san-jose.app1.cpu.idle`

Modifying this prefix allows you to customize how metrics are organized in
Graphite.

If you override the prefix, you will need to set `hostname` yourself if
desired. This allows you to place the hostname wherever in the path you want as
well.

Default: `hostname -s`

## Known Issues

The default `prefix` makes the plugin non-portable. On other UNIX `hostname -s`
might set the hostname to... `-s`. This is a TODO for Solarish support.)
