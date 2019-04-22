# frozen_string_literal: true

require 'ruby-static-tracing'

t = StaticTracing::Tracepoint.new('global', 'hello_world',
                                  Integer, String)
t.provider.enable

loop do
  if t.enabled?
    t.fire(StaticTracing.nsec, 'Hello world')
    puts 'Probe fired!'
  else
    puts 'Not enabled'
  end
  sleep 1
end
