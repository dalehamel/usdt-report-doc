# Future Work

## Kernel vs userspace buffering

It may not end up being an issue, but if probes are enabled (and fired!) persistently and frequently, the cost of the `int3` trap overhead may become significant.

uprobes allow for buffering trace event data in kernel space, but lttng-ust provides a means to buffer data in userspace.

This eliminates the necessity of the `int3` trap, and allows for buffering trace data in the userspace application rather than the kernel.

## ustack helpers in bpftrace

To have parity in debugging capabilities offered by dtrace, bpftrace needs to support the concept of a `ustack helper`.

As languages like `nodejs` have done, bpftrace and bcc should offer a means of reading annotations for JIT language instructions,
mapping them back to the source code that generated the JIT instruction. Examining the approach that `Nodejs` and `Python` have taken
to add support for ustack helpers, we should be able to generalize a means for `bpftrace` programs to interpret annotations for JIT instructions. [@dtrace-ustack-helpers]

Although ruby has a JIT under development, it would be ideal to have the code to annotate instructions for a ustack helper could be added
now.

If ruby's JIT simply wrote out notes in a way that would be easily loaded into a BPF map to notes by instruction, the eBPF probe can
just check against this map for notes, and then the `ustack` helper in bpftrace would simply need a means of specifying how
this map should be read when it is displayed.

This would allow for stacktraces that span ruby space (via the annotated JIT instructions), C methods (via normal ELF parsing), and the kernel itself.

While not actually related to directly USDT, ustack helpers in bpftrace and support for a ruby ustack helper would be tremendously impactful at understanding the full execution profile of ruby programs.
