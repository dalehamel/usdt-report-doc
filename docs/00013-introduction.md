# Introduction

## USDT - Userspace Statically Defined Tracepoints

USDT tracepoints are a powerful tool that gained popularity with `dtrace`.

In short, USDT tracepoints allow you to build-in diagnostics at key points of an application.

These can be used for debugging the application, measuring the performance characteristics, or analyzing any aspect of the runtime state of the program.

USDT tracepoints are placed within your code, and are executed when:

* They have been explicitly enabled.
* A tracing program, such as `bpftrace` or `dtrace` is connected to it.

## Portability

Originally limited to BSD, Solaris, and other systems with `dtrace`, it is now simple to use USDT tracepoints on Linux. `systemtap` for linux has produced `sys/sdt.h` that can be used to add dtrace probes to linux applications written in C, and for dynamic languages `libstapsdt` [@libstapsdt] can be used to add static tracepoints using whatever C extension framework is available for the language runtime. To date, there are wrappers for golang, Python, NodeJS, and a Ruby [@ruby-static-tracing] wrapper under development.

`bpftrace`'s similarity to `dtrace` allows for USDT tracepoints to be accessible throughout the lifecycle of an application.

While more-and-more developers use Linux, there are still a large representation of Apple laptops for professional workstations. Many such enterprises also deploy production code to Linux systems. In such situations, developers can benefit from the insights that `dtrace` tracepoints have to offer them on their workstation as they are writing code. Once the code is ready to be shipped, the tracepoints can simply be left in the application. When it comes time to debug or analyze the code in production, the very same toolchain can be applied by translating `dtrace`'s `.dt` scripts into `bpftrace`'s `.bt scripts.

Broad use of such tracepoints should be encouraged, as there is no performance downside to leaving them in the application. The greater the number of well-placed tracepoints in an application, the more tools developers will have at their disposal to gain insight into their application's real-world runtime characteristics.

## Performance

Critically, USDT tracepoints have little to no impact on performance if they are not actively being used.

This is what sets aside USDT tracepoints from other diagnostic tools, such as emitting metrics through statsd or writing to a logger.

This makes USDT tracepoints great to deploy surgically, rather than the conventional "always on" diagnostics. Logging data and emitting metrics do have some runtime overhead, and it is constant. The overhead that USDT tracepoints have is minimal, and limited to when they are actively being used to help answer a question about the behavior of an application.
