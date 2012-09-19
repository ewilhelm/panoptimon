require 'panoptimon/version'
require 'panoptimon/logger'
require 'panoptimon/monitor'
require 'panoptimon/collector'

require 'optparse'
require 'ostruct'

require 'rubygems'
require 'eventmachine'
require 'panoptimon/eventmonkeypatch/popen3.rb'

module Panoptimon

  class Panoptimon
  end

def self.load_options (args)
  defaults = {
    :daemonize      => true,
    :config_dir     => '/etc/panoptimon/',
    :config_file    => '%/panoptimon.json',
    :collectors_dir => '%/collectors',
    :plugins_dir    => '%/plugins',
    :collector_timeout  => 120,
    :collector_interval => 60,
  }

  options = ->() {
    o = {}
    OptionParser.new do |opts|

      opts.on('-c', '--config-file FILENAME',
        "Alternative configuration file ",
        "(#{defaults[:config_file]})"
      ) { |v| o[:config_file] = v.nil? ? '' : v }

      opts.on('-D', '--[no-]foreground',
        "Don't daemonize (#{not defaults[:daemonize]})"
      ) { |v| o[:daemonize] = ! v }

      ['config', 'collectors', 'plugins'].each { |x|
        k = "#{x}_dir".to_sym
        opts.on("--#{x}-dir DIR",
          "#{x.capitalize} directory (#{defaults[k]})"
        ) { |v| o[k] = v }
      }

      [:collectors, :plugins, :roles].each { |x|
        opts.on('--list-'+x.to_s, "list all #{x} found"
        ) { (o[:lists] ||= []).push(x) }
      }

      opts.on('-o', '--configure X=Y',
        'Set configuration values'
      ) { |x|
        (k,v) = x.split(/=/, 2)
        (o[:configure] ||= {})[k.to_sym] = v
      }

      opts.on('--show WHAT',
        %q{Show/validate settings for:  'config' / collector:foo / plugin:foo}
      ) { |x| (k,v) = x.split(/:/, 2)
        o[:show] = {k.to_sym => v||true}
      }

      opts.on('-l', '--location LOC', "Set node location"
        # TODO this feature might be implemented as a plugin
      ) { raise "--location unimplemented" }

      opts.on('-d', '--debug', "Enable debugging."
      ) { |v| o[:debug] = v }

      opts.on('--verbose', "Enable verbose output"
      ) { |v| o[:verbose] = v }

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail('-v', '--version', "Print version"
      ) { 
        puts "panoptimon version #{Panoptimon::VERSION}"
        o[:quit] = true
        opts.terminate
      }

      opts.on_tail("-h", "--help", "Show this message"
      ) {
        puts opts
        o[:quit] = true
        opts.terminate
      }

    end.parse!(args)

    return o
  }.call

  return false if options[:quit]

  render = ->(d, x) { # x with '%/' can be relative to dir d
    f = "#{x}"; f.sub!(/^%\//, '').nil? ? f : File.join(d, f)
  }

  # default config file is relative to config dir
  cfile = render.call(
    options[:config_dir]  || defaults[:config_dir],
    options[:config_file] || defaults[:config_file])

  config = defaults.merge(
    options[:config_file] == '' ? {} :
      JSON.parse(File.read(cfile), {:symbolize_names => true})
  ).merge(options);

  config[:config_file] = cfile # for diagnostics

  (config.delete(:configure) || {}).each { | k,v| config[k] = v }

  [:collectors_dir, :plugins_dir].each { |d|
    config[d] = render.call(config[:config_dir], config[d])
  }

  return OpenStruct.new(config).freeze

end

end

# vim:ts=2:sw=2:et:sta
