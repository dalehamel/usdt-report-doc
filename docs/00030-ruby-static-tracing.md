# ruby-static-tracing

While USDT tracepoints are conventionally defined in C and C++ applications with a pre-processor macro, `systemtap` has created their own library for `sdt` tracepoints, which implement the same API as dtrace, on Linux. A wrapper around this, `libstapsdt` is used to generate and load tracepoints in a way that can be used in dynamic languages like Ruby.

`ruby-static-tracing` is a gem that demonstrates the powerful applications of USDT tracepoints. It wraps `libstapsdt` for Linux support, and `libusdt` for Darwin / OS X support. This allows the gem to expose the same public Ruby api, implemented against separate libraries with specific system support.
