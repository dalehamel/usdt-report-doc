# USDT tracing in dynamic languages

## ruby-static-tracing

While USDT tracepoints are conventionally defined in C and C++ applications with a preprocessor macro, `systemtap` has created their own library for `sdt` tracepoints, which implement the same API as dtrace, on Linux. A wrapper around this, `libstapsdt` is used to generate and load tracepoints in a way that can be used in dynamic languages like Ruby.

`ruby-static-tracing` is a gem that demonstrates the powerful applications of USDT tracepoints. It wraps `libstapsdt` for Linux support, and `libusdt` for Darwin / OS X support. This allows the gem to expose the same public Ruby api, implemented against separate libraries with specific system support.

`ruby-static-tracing` implements wrappers for `libstapsdt` through C extensions. In creating a tracepoint, we are calling the C code:

```{.ruby include=src/ruby-static-tracing/ext/ruby-static-tracing/linux/tracepoint.c startLine=13 endLine=40}
```

And in firing a tracepoint, we're just wrapping the call in `libstapsdt`:

```{.ruby include=src/ruby-static-tracing/ext/ruby-static-tracing/linux/tracepoint.c startLine=54 endLine=71}
```

and the same for checking if a probe is enabled:

```{.ruby include=src/ruby-static-tracing/ext/ruby-static-tracing/linux/tracepoint.c startLine=81 endLine=87}
```

So, we will dive into how `libstapsdt` works, to explain how we're able to probe Ruby from the kernel.
