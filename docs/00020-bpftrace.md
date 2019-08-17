# bpftrace

bpftrace [@bpftrace] is an emerging new tool that is takes advantage of on eBPF
support added to version 4.1 of the linux kernel. While rapidly under
development, it already supports much of dtrace's functionality and is now hit
a fairly stable state with most of the important features implemented, ready
more or less for production use.

You can use bpftrace in production systems to attach to and summarize data from
trace points similarly to with dtrace.  You can run bpftrace programs by
specifying a string with the `-e` flag, or by running a bpftrace script
(conventionally ending in `.bt`) directly.

To quickly overview how bpftrace works:

- As `awk` treats lines, `bpftrace` treats probe events. You can select the
type of event you want a probe to fire on, and define the probe in a stanza
- bpftrace probes generate LLVM IR that is converted to eBPF instructions
- The bpftrace executable reads data from eBPF maps to userspace in order to
display, format, and summarize it
- eBPF programs are loaded into the kernel, and fire on uprobe, kprobe,
tracepoint, and other events

For more details for bpftrace, check out its own reference guide
[@bpftrace-reference-guide] and this great article [@joyful-bikeshedding-bpftrace].
I started a separate report, annotating my contributions to bpftrace and
explaining them, to share my insight of bpftrace internals [@bpftrace-internals-doc].

There is an upcoming book [@bgregg-perf-tools-book] from Brendan Gregg that I
covers a lot of great topics and uses of bpftrace which I highly recommend any
reader pre-order, as it will certainly be the definitive book on eBPF for
performance engineers.
