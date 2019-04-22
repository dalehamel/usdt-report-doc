# Future Work

## More tracers for ruby-static-tracing

We'd like to see more tracers in `ruby-static-tracing`, and hopefully user-contributed ones as well.

There is potential for exploration of other aspects of ruby internals through USDT probes as well, such as `ObjectSpace` insights.

Through parsing headers, you may be able to use `ruby-static-tracing` to augment distributed traces, if you can hook up to the right span.

## Kernel vs userspace buffering

It may not end up being an issue, but if probes are enabled (and fired!) persistently and frequently, the cost of the `int3` trap overhead may become significant.

uprobes allow for buffering trace event data in kernel space, but lttng-ust provides a means to buffer data in userspace [@lttng-ust-ebpf]. This eliminates the necessity of the `int3` trap, and allows for buffering trace data in the userspace application rather than the kernel. This approach could be used to aggregate events and perform fewer trap interrupts, draining the userland buffers during each eBPF read-routine.

While `lttng-ust` does support userspace tracing of C programs already [@lttng-ust-manpage], in a way analogously to `sys/sdt.h`, there is no solution for a dynamic version an `lttng-ust` binary. Like `DTRACE` macros, the `lttng-ust` macros are used to build the handlers, and they are linked-in as a shared object. In the same way that libstapsdt builds elf notes, it's possible that a generator for the shared library stub produced by `lttng-ust` could be built. A minimum proof of concept would be a JIT compiler that compiles a generated header into an elf binary that can be `dlopen`'d to map it into the tracee's address space.

Analyzing the binary of a lttng-ust probe may give some clues as to how to build a minimal stub dynamically, as `libstapsdt` has done for `systemtap`'s `dtrace` macro implementation.

Implementing userspace support in libraries like `ruby-static-tracing` [@ruby-static-tracing] by wrapping `lttng-ust` could also offer a means of using userspace tracepoints for kernels not supporting eBPF, and an interesting benchmark comparison of user vs kernel space tracing, perhaps offering complementary approaches [@lttng-ust-ebpf].

## ustack helpers in bpftrace

To have parity in debugging capabilities offered by dtrace, bpftrace needs to support the concept of a `ustack helper`.

As languages like `nodejs` have done, bpftrace and bcc should offer a means of reading annotations for JIT language instructions,
mapping them back to the source code that generated the JIT instruction. Examining the approach that `Nodejs` and `Python` have taken
to add support for ustack helpers, we should be able to generalize a means for `bpftrace` programs to interpret annotations for JIT instructions. [@dtrace-ustack-helpers]

## Ruby JIT notes

Although ruby has a JIT under development [@ruby-jit], it would be ideal to have the code to annotate instructions for a ustack helper could be added
now.

If ruby's JIT simply wrote out notes in a way that would be easily loaded into a BPF map to notes by instruction, the eBPF probe can
just check against this map for notes, and then the `ustack` helper in bpftrace would simply need a means of specifying how
this map should be read when it is displayed.

This would allow for stacktraces that span ruby space (via the annotated JIT instructions), C methods (via normal ELF parsing), and the kernel itself. Hopefully offering similar functionality to what has been provided to nodejs [@nodejs-david-pacheco].

While not actually related to directly USDT, ustack helpers in bpftrace and support for a ruby ustack helper would be tremendously impactful at understanding the full execution profile of ruby programs.

Ruby JIT is experimental and possibly to enable with `--jit` flag in 2.6 and higher. Perhaps adding JIT notes in a conforming way early could help to increase visibility into JIT'd code?
## BTF support

For introspecting userspace applications, BTF [@facebook-btf] looks like it will be useful for deeper analysis of a variety of typed-objects.

This may also free bpftrace and bcc from the need fork kernel headers, if the kernel type information can be read directly from BPF maps. For userspace programs, they may need to be compiled with BTF type information available, or have this information generated and loaded elsewhere somehow. This would be useful for analyzing the C components of language runtimes, such tracing the internals of the ruby C runtime, or analyzing C/C++ based application servers or databases.

BTF support requires a kernel v4.18 or newer, and the raw BTF documentation is available in the kernel sources [@kernel-btf]. Few userspace tools exist for BTF yet, but once it is added into tools like `libbcc` and `bpftrace`, a whole new realm of possibilities for debugging and tracing applications is possible.
