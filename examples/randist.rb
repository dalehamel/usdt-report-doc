#!/usr/bin/env ruby

require 'ruby-static-tracing'

t = StaticTracing::Tracepoint.new('global', 'randist', Integer)
t.provider.enable

r = Random.new

loop do
  t.fire(r.rand(100))
end
