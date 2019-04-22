# Adding USDT support to a dynamic language

## ruby-static-tracing

While USDT tracepoints are conventionally defined in C and C++ applications with a preprocessor macro, `systemtap` has created their own library for `sdt` tracepoints, which implement the same API as dtrace, on Linux. A wrapper around this, `libstapsdt`[@libstapsdt] is used to generate and load tracepoints in a way that can be used in dynamic languages like Ruby.

`ruby-static-tracing` is a gem that demonstrates the powerful applications of USDT tracepoints. It wraps `libstapsdt` for Linux support, and `libusdt` for Darwin / OS X support. This allows the gem to expose the same public Ruby api, implemented against separate libraries with specific system support. Both of these libraries are vendored-in, and dynamically linked via `RPATH` modifications. On Linux, `libelf` is needed to build and run `libstapsdt`, on Darwin, `libusdt` is built as a dylib and loaded alongside the `ruby_static_tracing.so` app bundle.

`ruby-static-tracing` implements wrappers for `libstapsdt` through C extensions. The scaffold / general design of `ruby-static-tracing` is based on the [semian gem](https://github.com/Shopify/semian), and in the same way that Semian supports helpers to make it easier to use, we hope to mimic and take inspiration many of the same patterns to create tracers. Credit to the Semian authors Scott Francis [@csfrancis] and Simon Hørup Eskildsen [@sirupsen] for this design as starting point.

In creating a tracepoint, we are calling the C code:

```{.c include=src/ruby-static-tracing/ext/ruby-static-tracing/linux/tracepoint.c startLine=13 endLine=40}
```

You can see that the tracepoint will register a provider for itself if it hasn't happened already, allowing
for "implicit declarations" of providers on their first reference.

And in firing a tracepoint, we're just wrapping the call in `libstapsdt`:

```{.c include=src/ruby-static-tracing/ext/ruby-static-tracing/linux/tracepoint.c startLine=54 endLine=71}
```

and the same for checking if a probe is enabled:

```{.c include=src/ruby-static-tracing/ext/ruby-static-tracing/linux/tracepoint.c startLine=81 endLine=87}
```

In general, all of the direct `provider` and `tracepoint` functions are called directly through these C-extensions, wrapping around `libstapsdt` [@libstapsdt].

So to understand what happens when we call a tracepoint, we will need to dive into how `libstapsdt` works, to explain how we're able to probe Ruby from the kernel.
