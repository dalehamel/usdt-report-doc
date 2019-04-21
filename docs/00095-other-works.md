# USDT tracing alternatives

What distinguishes USDT tracepoints from a variety of other profiling and debugging tools is that other tools are
generally either:

- Sampling profilers
- Trace every method invocation
- Require interrupting / stopping the program

This approach to tracing uses the x86 breakpoint instruction (`INT3 0xCC`) to trigger a kernel trap handler that will hand off execution to an eBPF probe.
This use of breakpoints - injected by the kernel into the application via the kernel `uprobe` API, gives us the ability to perform targeted debugging on production systems.

Rather than printing to a character device (such as a log), or emitting a UDP or TCP based metric, USDT probes fire a kernel trap-handler.
This allows for the kernel to do the work of collecting the local state, and summarizing it in eBPF maps.

breakpoints are only executed when there is an eBPF program installed and registered to handle the breakpoint.
If there is nothing registered to the breakpoint, it is not executed. The overhead of this is nanoseconds.

For this reason, USDT tracepoints should be safe for use in production. The surgical precision that they offer
in targeting memory addresses within the ruby execution context, and low overhead, make them a powerful tool.

It is less for generating flamegraphs of an application as a whole, and more for drilling in deep on a particular
area of code

## ptrace API

### gdb

gdb can be used to debug applications, but generally requires a lot of overhead

### strace

## process\_vm\_readv

`rbspy` https://rbspy.github.io/using-rbspy/

* rbspy [@rbspy-github-io]
* rbspy vs stackprof [@rbspy-vs-stackprof]

## signaling 

`rbtrace` https://github.com/tmm1/rbtrace/blob/master/ext/rbtrace.c
* stackprof github [@stackprof-github]
* rbtrace github [@rbtrace-github]

## Ruby

### Tracing api

Most standard debuggers for ruby use ruby's built-in tracing API. Ruby in fact already has `DTRACE` probes.
What distinguishes `ruby-static-tracing` from these other approaches is that USDT tracepoints are compiled-in to the application.
Ruby's tracing API is an "all or nothing" approach, affecting the execution of every single method. With USDT tracing, trace
data is collected at execution time when a tracing breakpoint instruction is executed.

* rotoscope [@rotoscope-github]
