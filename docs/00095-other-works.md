# USDT tracing alternatives

What distinguishes USDT tracepoints from a variety of other profiling and
debugging tools is that other tools are generally either:

- Sampling profilers
- Trace every method invocation
- Require interrupting / stopping the program

This approach to tracing uses the x86 breakpoint instruction (`INT3 0xCC`) to
trigger a kernel trap handler that will hand off execution to an eBPF probe.
This use of breakpoints - injected by the kernel into the application via the
kernel `uprobe` API, gives us the ability to perform targeted debugging on
production systems.

Rather than printing to a character device (such as a log), or emitting a UDP
or TCP based metric, USDT probes fire a kernel trap-handler. This allows for
the kernel to do the work of collecting the local state, and summarizing it in
eBPF maps.

breakpoints are only executed when there is an eBPF program installed and
registered to handle the breakpoint. If there is nothing registered to the
breakpoint, it is not executed. The overhead of this is nanoseconds.

For this reason, USDT tracepoints should be safe for use in production. The
surgical precision that they offer in targeting memory addresses within the
Ruby execution context, and low overhead, make them a powerful tool.

It is less for generating flamegraphs of an application as a whole, and more
for drilling in deep on a particular area of code

## ptrace API

The ptrace API is a standard implementation for spying on processes and has
been used to build some of the standard and widely used debugging tools.

### gdb

gdb can be used to debug applications, but generally requires a lot of overhead.

A colleague of mine, Scott Francis [@csfrancis] wrote a very interesting blog
post [@adventures-rails-debugging] about using gdb collect a core dump from
a live production process, and analyze it out-of-band.

### strace

strace is great for seeing what system calls a program is doing, but isn't
particularly useful for debugging Ruby code itself, as it is just an running
userspace code to interpret source files into bytecode it can execute.

When Ruby goes to make a syscall for an IO request, or to make a lot of stdlib
calls though, strace can be great at finding out if a Ruby process is having
issues with system resources.

Strace is nice because you can attach and detach, follow forks, and generally
try to get an idea of what a given process is interacting with the system for.

Used during startup, you can see all of the require statements that happen in
order for a Ruby (and especially Rails) process to boot

## rbspy

Rbspy [@rbspy-github-io] was written by Julia Evans [@jvns] and taps into a
Ruby process using `process_vm_readv`.

Rbspy is written in Rust, and basically finds the address within a Ruby process
where the Stack trace is in order to read 

```{.rust include=src/rbspy/src/core/initialize.rs startLine=17 endLine=38}
```

rbspy provides similar functionality to stackprof [@rbspy-vs-stackprof], as
both are sampling profilers. The cool thing about rbspy is that you don't the
Ruby process doesn't need to require a Gem to use it, since it works under the
hood by fundamentally just copying data out of the Ruby address space using
a syscall.

## rbtrace

rbtrace [@rbtrace-github] by Aman Gupta [@tmm1] uses Ruby's tracing API to
register its own event hooks with `rb_add_event_hook`.

```{.c include=src/rbtrace/ext/rbtrace.c startLine=522 endLine=536}
```

This provides functionality similar to what is available through Ruby `dtrace`
probes for external observation, but is done in userspace by requiring the
`rbtrace` Gem, which sets up handlers upon receiving `SIGURG`.

rbtrace is an extremely powerful and valuable tool, and something that USDT
support should aim far parity with.

Ultimately, rbtrace receives and handles every type of event while it has been
enabled on a process, and is an event-processing driven architecture.

## stackprof

stackprof [@stackprof-github] is another tool by Aman Gupta [@tmm1], but is a
sampling profiler rather than an event processor.

Stackprof also uses Ruby tracing API for object tracing:

```{.c include=src/stackprof/ext/stackprof/stackprof.c startLine=102 endLine=106}
```

But otherwise just registers a timer that will handle generating the profiling
signal:

```{.c include=src/stackprof/ext/stackprof/stackprof.c startLine=107 endLine=118}
```

This will trigger a handler when the timer fires:

```{.c include=src/stackprof/ext/stackprof/stackprof.c startLine=560 endLine=570}
```

Which than records records the profiling data after a few calls:

```{.c include=src/stackprof/ext/stackprof/stackprof.c startLine=490 endLine=504}
```

## Ruby

### Tracing api

Most standard debuggers for ruby use ruby's built-in tracing API. Ruby in fact
already has `DTRACE` probes. What distinguishes `ruby-static-tracing` from
these other approaches is that USDT tracepoints are compiled-in to the
application. Ruby's tracing API is an "all or nothing" approach, affecting the
execution of every single method. With USDT tracing, trace data is collected at
execution time when a tracing breakpoint instruction is executed.

* rotoscope [@rotoscope-github]

Update: As of Ruby 2.6, it is now possible to do this thanks to
[@ruby-tracing-feature-15289]! You can see the official docs
[@ruby-2-6-tracing-docs] for more details, but it's currently a bit light as
it's a pretty new API.
