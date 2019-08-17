# Acknowledgments

This is a report is meant to summarize my own research and experiments in this area, but the experience and research that went into making it all possible bears mentioning.

- Brendan Gregg [@brendangregg] for his contributions to improving the
accessibility of tracing tools throughout the industry
- Alastair Robertson [@ajor] for creating bpftrace, and personally for
reviewing the PRs I've submitted and offering insightful feedback
- Matheus Marchini [@mmarchini] for his contributions to USDT tracing and
feedback in reviews
- Willian Gaspar [@williangaspar] for his contributions to iovisor and works
featured here
- Jon Haslam [@tyroguru] for his assistance and feedback on pull requests for
USDT functionality in bpftrace
- Teng Qin [@palmtenor] for reviewing my BCC patches with laser eyes
- Yonghong Song [@yonghong-song] for reviewing my BCC patches with laser eyes
- Julia Evans [@jvns] for her amazing zines on tracing, rendering advanced
concepts in accessible and creative formats, and her technical contributions to
the tracing community and rbspy
- Lorenzo Fontana [@fntlnz] for his work on creating and promoting kubetl-trace
- Leo Di Donato [@leodido] for his work feedback and and insights on pull
requests

I'd also like to specifically extend appreciation to Facebook and Netflix's
Engineering staff working on tracing and kernel development, for their
continued contributions and leadership in the field of Linux tracing and
contributions to eBPF, as well as the entire iovisor group.

## Works Researched

Some of these may have been cited or sourced indirectly, or were helpful in
developing a grasp on the topics above, whether I've explicitly cited them or
not. If you'd like to learn more, check out these other resources:

- Hacking Linux USDT with ftrace [@bgregg-usdt-ftrace]
- USDT for reliable Userspace event tracing [@joel-fernandes-usdt-notes]
- We just got a new super-power! Runtime USDT comes to Linux [@usdt-superpower]
- Seeing is Believing: uprobes and int3 Instruction [@uprobes-int3-insn]
- Systemtap UST wiki [@stap-wiki-ust]
- Systemtap uprobe documentation [@stap-uprobe-documentation]
- Linux tracing systems & how they fit together [@jvns-tracing-systems]
- Full-system dynamic tracing on Linux using eBPF and bpftrace [@joyful-bikeshedding-bpftrace]
- Awesome Dtrace - A curated list of awesome DTrace books, articles, videos,
tools and resources [@awesome-dtrace]

# Caveats

This is intended audience of this work is performance engineers, who wish to
familiarize themselves with USDT tracing in both development (assuming Mac OS,
Linux, or any platform that supports Vagrant, or Docker on a hypervisor with a
new enough kernel), and production (assuming Linux, with kernel 4.14 or
greater, ideally 4.18 or greater) environments.

## Unmerged patches

The following demonstrates the abilities of unreleased and in some cases
unmerged branches, so some of it may be subject to change.

The following pull requests are assumed merged in your local development
environment:

* [Support for writing ELF notes to a memfd backed file descriptor in libstapsdt](https://github.com/sthima/libstapsdt/pull/24)
for storing ELF notes in a memory-backed file, to avoid having to clean up ELF
blobs accumulating in `/tmp` directory when a probed program exits uncleanly.
Presently **UNMERGED**, but is used by `ruby-static-tracing` by default and
will probably be the default for `libstapsdt` after some rework. This is only
an issue if you find the need to build `libstapsdt` yourself, and want to use
memory-backed file descriptors.
* [Build ubuntu images and use them by default in kubectl trace](https://github.com/iovisor/kubectl-trace/pull/52)
for the kubectl trace examples here.

For the submodules of this repository, we reference these branches accordingly,
until (hopefully) all are merged and have a point release associated with them.

You also must have a kernel that supports all of the bpftrace/bcc features. To
probe userspace containers on overlayfs, you need kernel `4.18` or later. A
minimum of kernel `4.14` is needed for many examples here.
