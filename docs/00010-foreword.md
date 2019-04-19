# Foreword

This document is an open-source report on Userspace Statically Defined Tracepoints (USDT). The document source is available on [github](https://github.com/dalehamel/usdt-report-doc). If you find any errors or omissions, please file an issue or submit a pull request. It is meant to be a useful manual, with reference implementations and runnable examples. It will also explain how USDT probes work on linux end-to-end, and demonstrate some practical applications of them.

This is intended audience of this work is performance engineers, who wish to familiarize themselves with USDT tracing in both development (assuming Mac OS, Linux, or any platform that supports Vagrant, or Docker on a hypervisor with a new enough kernel), and production (assuming Linux, with kernel 4.14 or greater, ideally 4.18 or greater) environments.

This document is prepared with pandoc markdown, so it is available for donwload as an [epub](http://blog.srvthe.net/usdt-report-doc/output/doc.epub), [mobi](http://blog.srvthe.net/usdt-report-doc/output/doc.mobi), or [pdf](http://blog.srvthe.net/usdt-report-doc/output/doc.pdf) version of this document, if you prefer. You can read the epub with a browser extension such as [epubreader for chrome](https://chrome.google.com/webstore/detail/epubreader/jhhclmfgfllimlhabjkgkeebkbiadflb?hl=en), or [epubreader for firefox](https://addons.mozilla.org/en-CA/firefox/addon/epubreader/). The epub is the most enjoyable to read, the PDF is more academically formatted, and the html is meant for broad accessiblity. Enjoy!

// FIXME add mobi
