# libusdt

`ruby-static-tracing` [@ruby-static-tracing] also wraps `libusdt` for
Darwin / OSX support.

libusdt is the provider used for dtrace probes and many of the examples
powering the libraries on [@awesome-dtrace]. This library supports a number of
platforms other than Linux, including BSDs and Solaris, and really anything
that ships with dtrace. It is worth examining dtrace, in order to see its
impact on the design of Systemtap's implementation of the original dtrace
APIs.

The ELF notes used by systemtap, and libstapsdt are based on the DOF format:

```{.c include=src/darwin-xnu/bsd/sys/dtrace.h startLine=691 endLine=723}
```

This notation is what describes to the Kernel tracing helper, in this case BCC,
in order to determine the offsets of tracepoints within the memory space of
the program being traced.

This format is widely used for debugging, and provides a debug faculty that is
portable across frameworks, languages, and thanks to libstapsdt and libusdt.

Many programming runtimes already have USDT support via adherence to the
existing dtrace USDT api.
