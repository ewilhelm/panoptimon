# Graphite Plugin

This plugin emits metrics to Graphite.

# Supported Platforms

* Linux
* *others untested*

# Metric Names

The panoptimon field separator is '|', but graphite uses '.' or '/'.
The metric names emitted by this plugin will be rewritten to use '.'
as a field separator, and any existing '.' or '/' characters are
replaced with '_'.  This *could* cause a conflict with some metrics,
but is rather unlikely.

    example: disk|/dev/sda3|space_used
    becomes: disk._dev_sda3.space_used

# Configuration

### graphite.json example

````
{
  "host": "graphite.example.com",
  "port": 2003,
  "prefix": "env.location.foo"
}
````

## `host`

The name or IP of your Graphite server

Default: `localhost`

## `port`

The port carbon is listening on.

Default: `2003`

## `prefix`

The prefix to the path streamed to Graphite. For instance, if you set
`prefix` to `qa.san-jose.app1`, the full CPU idle path Graphite receives
will be `qa.san-jose.app1.cpu.idle`.  This allows you to customize how
metrics are organized in Graphite.

Default: `<%= host %>`

The erb-like strings `<%= host %>` and `<%= domain %>` will be replaced
(respectively) with the first and remaining dot-separated parts of your
host name.
