#!/opt/ruby/bin/ruby
#
# Riemann data feeder
# Feed json directly to a Riemann server
#
# Copyright Sourcefire, 2012
# Benjamin Krueger <bkrueger@sourcefire.com>

require 'rubygems'
require 'json'
require 'riemann/client'

input_json = JSON[STDIN.read]

puts "Service: #{input_json['service']}"
puts "State: #{input_json['state']}"
puts "Metric: #{input_json['metric']}"
puts "Description: #{input_json['description']}"

def submitEvent(event)
  # New Riemann client
  c = Riemann::Client.new host: 'riemann.example.com', port: 5555

  # Send event to Riemann server
  c << {
    service: event['service'],
    state: event['state'],
    metric: event['metric'].to_i,
    description: event['description']
  }
end

submitEvent(input_json)
