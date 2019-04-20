# libstapsdt

Lib


The function `funcStart` is defined in an assembly file. You might be cringing at the thought of working with assembly directly, but this definition is quite simple:


```{.gnuassembler include=src/ruby-static-tracing/ext/ruby-static-tracing/lib/libstapsdt/src/asm/libstapsdt-x86_64.s startLine=7 endLine=12}
```

It simply inserts four `NOP` instructions, followed by a `RET`. In case you don't speak assembly, this translates to instructions that say to "do nothing, and then return".
