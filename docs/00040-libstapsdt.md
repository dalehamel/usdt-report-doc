## libstapsdt

This library was written by Matheus Marchini [@mmarchini] and Willian Gaspar [@williangaspar], and provides a means of generating elf notes in a format compatible to `DTRACE` macros for generating elf notes on linux.

For each provider declared, `libstapsdt` will create an `ELF` file that can be loaded directly into ruby's address space through `dlopen`. As a compiler would normally embed these notes directly into a C program, `libstapsdt` matches this output format exactly. Once all of the tracepoints have been registered against a provider, it can be loaded into the ruby process's address space through a `dlopen` call on a file descriptor for a temporary (or memory-backed) file containing the ELF notes.

For each tracepoint that we add to each provider, `libstapsdt` will inject assembly for the definition of a function called `_funcStart`. This function is defined in an assembly file. You might be cringing at the thought of working with assembly directly, but this definition is quite simple:


```{.gnuassembler include=src/ruby-static-tracing/ext/ruby-static-tracing/lib/libstapsdt/src/asm/libstapsdt-x86_64.s startLine=7 endLine=12}
```

It simply inserts four `NOP` instructions, followed by a `RET`. In case you don't speak assembly, this translates to instructions that say to "do nothing, and then return".

The address of this blob of assembly is used as the address of the function `probe._fire` in `libstapsdt`. So, each probe is calling into a memory region that we've dynamically loaded into memory, and the addresses of these probes can be computed by reading the elf notes on these generated stubs.

To understand this better, we'll dive into how `libstapsdt` works. This will take us all the way from the Ruby call, to down inside the kernel.
