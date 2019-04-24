---
title: USDT Tracing report
author: Dale Hamel

---

# Foreword


This document is prepared with pandoc markdown, and available in the following formats:

* [epub](http://blog.srvthe.net/usdt-report-doc/output/doc.epub)
* [mobi (for kindle)](http://blog.srvthe.net/usdt-report-doc/output/doc.mobi)
* [pdf (in academic \LaTeX format)](http://blog.srvthe.net/usdt-report-doc/output/doc.pdf)

You can read the epub with a browser extension such as [epubreader for chrome](https://chrome.google.com/webstore/detail/epubreader/jhhclmfgfllimlhabjkgkeebkbiadflb?hl=en), or [epubreader for firefox](https://addons.mozilla.org/en-CA/firefox/addon/epubreader/). The epub is the most enjoyable to read, the PDF is more academically formatted, and the html is meant for broad accessibility. Enjoy!

This document is an open-source report on Userspace Statically Defined Tracepoints (USDT). The document source is available on [github](https://github.com/dalehamel/usdt-report-doc). If you find any errors or omissions, please file an issue or submit a pull request. It is meant to be a useful manual, with reference implementations and runnable examples. It will also explain how USDT probes work on linux end-to-end, and demonstrate some practical applications of them.

This is intended audience of this work is performance engineers, who wish to familiarize themselves with USDT tracing in both development (assuming Mac OS, Linux, or any platform that supports Vagrant, or Docker on a hypervisor with a new enough kernel), and production (assuming Linux, with kernel 4.14 or greater, ideally 4.18 or greater) environments.

## Disclaimer

The following demonstrates the abilities of unreleased and in some cases unmerged branches, so some of it may be subject to change.

The following pull requests are assumed merged in your local development environment:

* [USDT wildcard functionality for bpftrace](https://github.com/iovisor/bpftrace/pull/508) for listing USDT probes and attaching to multiple probes. Otherwise, use `tplist` from `bcc-tools`. Presently **UNMERGED**. You must apply this branch yourself.
* [Add bcc_usdt_enable_fully_specified_probe to avoid usdt provider collisions](https://github.com/iovisor/bcc/pull/2294) for allowing specification of namespace to avoid collisions. Otherwise, wildcards may cause collisions. Presently **MERGED**, you just need to run and build [this commit of BCC](https://github.com/iovisor/bcc/commit/33bffcaadcf3bd70807dc1de1145de54b6b7ab67) or later on the `master` branch until the next bcc release.
* [USDT support for loading elf notes from /memfd backed file handle](https://github.com/iovisor/bcc/pull/2314), and [this fix for a possible memory leak](https://github.com/iovisor/bcc/pull/2320) that @palmtenor spotted. Presently both **MERGED** you just need to run and build against [this commit of BCC](https://github.com/iovisor/bcc/commit/440268ea744662b32087087342e29ea8ab186f79) or later on the `master` branch until the next bcc release.
* [Support for writing ELF notes to a memfd backed file descriptor in libstapsdt](https://github.com/sthima/libstapsdt/pull/24) for storing ELF notes in a memory-backed file, to avoid having to clean up elf blobs accumulating in `/tmp` directory when a probed program exits uncleanly. Presently **UNMERGED**, but is used by `ruby-static-tracing` by default and will probably be the default for `libstapsdt` after some rework. This is only an issue if you find the need to build `libstapsdt` yourself, and want to use memory-backed file descriptors.
* [Build ubuntu images and use them by default in kubectl trace](https://github.com/iovisor/kubectl-trace/pull/52) for the kubectl trace examples here.

For the submodules of this repository, we reference these branches accordingly, until (hopefully) all are merged and have a point release associated with them.

You also must have a kernel that supports all of the bpftrace/bcc features. To probe userspace containers on overlayfs, you need kernel `4.18` or later. A minimum of kernel `4.14` is needed for many examples here.
