# Panoptimon

The All-Seeing System Monitor Daemon

## Installation

    $ gem install panoptimon

## Usage

The `--config-dir` option will automatically set paths to configuration
file, collectors, and plugins (and can be referred to as '%' as shown
below.)

    $ panoptimon --help
    Usage: panoptimon [options]
      -C, --config-dir DIR             Config directory (/etc/panoptimon/)
      -c, --config-file FILENAME       Alternative configuration file 
                                       (%/panoptimon.json)
      -D, --[no-]foreground            Don't daemonize (false)
          --collectors-dir DIR         Collectors directory (%/collectors)
          --plugins-dir DIR            Plugins directory (%/plugins)
          --list-collectors            list all collectors found
          --list-plugins               list all plugins found
      -o, --configure X=Y              Set configuration values
          --show WHAT                  Show/validate settings for:
                                         'config' / collector:foo / plugin:foo
          --plugin-test FILE           Load and test plugin(s).
      -d, --debug                      Enable debugging.
          --verbose                    Enable verbose output
      -v, --version                    Print version
          --help-defaults              Show default config values
      -h, --help                       Show this message

See [the wiki](https://github.com/synthesist/panoptimon/wiki) for more
info.

## Copyright and License

This software is released under the following (BSD 3-clause) license:

Copyright (C) 2012 Sourcefire, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

  * Neither the name of *Sourcefire, Inc.* nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
