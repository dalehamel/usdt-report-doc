#!/usr/bin/env ruby

require 'ruby-static-tracing'

DEBUG = ENV['DEBUG']

t = StaticTracing::Tracepoint.new('global', 'hello_nsec', Integer, String)
e = StaticTracing::Tracepoint.new('global', 'enabled', Integer)

puts t.provider.enable

while true do
  i = StaticTracing.nsec

  if t.enabled?
    d = StaticTracing.nsec
    e.fire(d-i) if e.enabled?
    t.fire(StaticTracing.nsec, "Hello world")
    f = StaticTracing.nsec
#    puts "Probe fired!"
  else
    d = StaticTracing.nsec
    e.fire(d-i) if e.enabled?
#    puts "Not enabled"
  end
  sleep 0.01
end
