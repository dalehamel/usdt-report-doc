## Kernel vs userspace buffering

It may not end up being an issue, but if probes are enabled (and fired!) persistently and frequently, the cost of the `int3` trap overhead may become significant.

uprobes allow for buffering trace event data in kernel space, but lttng-ust provides a means to buffer data in userspace.

This elminates the necessity of the `int3` trap, and allows for buffering trace data in the userspace application rather than the kernel.
