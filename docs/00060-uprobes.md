## Examining the dynamically loaded ELF

For our ruby process with a loaded provider, we can see the provider in the address space of the process:

```
cat /proc/22205/maps | grep libstapsdt:global

```

```bash
7fc624c3b000-7fc624c3c000 r-xp [...] 9202140   /memfd:libstapsdt:global (deleted)
7fc624c3c000-7fc624e3b000 ---p [...] 9202140   /memfd:libstapsdt:global (deleted)
7fc624e3b000-7fc624e3c000 rw-p [...] 9202140   /memfd:libstapsdt:global (deleted)
```

The left-most field is the process memory that is mapped to this library. Note that it appears 3 times,
for the different permission modes of the memory (second column). The number in the center is the inode
associated with our memory image, and it is identical for all of them because they are all backed by
the same memory-only file descriptor. This is why, to the very right, we see `(deleted)` - the file
descriptor doesn't actually exist on the filesystem at the address specified.

This is because we are using a memory-backed file descriptor to store the ELF notes. The value shown
here for `/memfd:[...]` is a special annotation for file descriptors that have no backing file and
exist entirely in memory. We do this so that we don't have to clean up the generated ELF files manually.

In examining the file descriptors for this process, we find that one of them matches the name and apparent
path of this file memory mapped segment:

```
$ readlink -f /proc/22205/fd/*
/dev/pts/11
/dev/pts/11
/dev/pts/11
/proc/22205/fd/pipe:[9202138]
/proc/22205/fd/pipe:[9202138]
/proc/22205/fd/pipe:[9202139]
/proc/22205/fd/pipe:[9202139]
/memfd:libstapsdt:global (deleted)
/dev/null
/dev/null
```

It happens to be at the path `/proc/22205/fd/7`. If we read our elf notes for this path, we get what we expect:

```
readelf --notes /proc/22205/fd/7
```

```gnuassembler

Displaying notes found in: .note.stapsdt
  Owner                 Data size       Description
  stapsdt              0x00000039       NT_STAPSDT (SystemTap probe descriptors)
    Provider: global
    Name: hello_nsec
    Location: 0x0000000000000280, Base: 0x0000000000000340, Semaphore: 0x0000000000000000
    Arguments: 8@%rdi -8@%rsi
  stapsdt              0x0000002e       NT_STAPSDT (SystemTap probe descriptors)
    Provider: global
    Name: enabled
    Location: 0x0000000000000285, Base: 0x0000000000000340, Semaphore: 0x0000000000000000
    Arguments: 8@%rdi
```

And, if we just read the memory space directly using the addresses for our ELF blob earlier:

```
readelf --notes /proc/22205/map_files/7fc624c3b000-7fc624c3c000
```

```gnuassembler

Displaying notes found in: .note.stapsdt
  Owner                 Data size       Description
  stapsdt              0x00000039       NT_STAPSDT (SystemTap probe descriptors)
    Provider: global
    Name: hello_nsec
    Location: 0x0000000000000280, Base: 0x0000000000000340, Semaphore: 0x0000000000000000
    Arguments: 8@%rdi -8@%rsi
  stapsdt              0x0000002e       NT_STAPSDT (SystemTap probe descriptors)
    Provider: global
    Name: enabled
    Location: 0x0000000000000285, Base: 0x0000000000000340, Semaphore: 0x0000000000000000
    Arguments: 8@%rdi
```

We see that it matches exactly!

Notice that the location of `global:hello_nsec` is `0x0280` in the elf notes.

Now we will use `gdb` to dump the memory for our program so that we can examine the hexadecimal of its address space.

```
sudo gdb --pid 22205
(gdb) dump memory unattached 0x7fc624c3b000 0x7fc624c3c000
```

```
hexdump -C unattached
```

```{.gnuassembler include=examples/hello-world.hexdump startLine=36 endLine=45}

```

Lets take a closer look at that address 0x280:

```gnuassembler
00000280  90 90 90 90 c3 90 90 90  90 c3 00 00 00 00 00 00  |................|
```

Those first 5 bytes look familiar! Recall the definition of `_funcStart` earlier:

```{.gnuassembler include=src/ruby-static-tracing/ext/ruby-static-tracing/lib/libstapsdt/src/asm/libstapsdt-x86_64.s startLine=7 endLine=12}
```

The assembly instruction `NOP` corresponds to `0x90` on x86 platforms, and the assembly instruction `RET` corresponds to `0xc3`. So, we're
looking at the machine code for the stub function that we created with `libstapsdt`. This is the code that will be executed every time we call `fire`
in userspace. The processor will run four `NOP` instructions, and then return.

As we can see in `libstapsdt`, the address of `probe._fire` is set from the location of the probe's name, as calculated from the ELF offset:

```{.c include=src/ruby-static-tracing/ext/ruby-static-tracing/lib/libstapsdt/src/libstapsdt.c startLine=154 endLine=165}
```

So this is what the memory space looks like where we've loaded our ELF stubs, and we can see how userspace `libstapsdt` operations work.

For instance, the code that checks if a provider is enabled:

```{.c include=src/ruby-static-tracing/ext/ruby-static-tracing/lib/libstapsdt/src/libstapsdt.c startLine=235 endLine=243}

```

It is simply checking the memoryspace to see if the address of the function starts with a `NOP` instruction (`0x90`).

Now, if we attach to our program with `bpftrace`, we'll see the effect that attaching a uprobe to this address will have.

Dumping the same memory again with `gdb`:


```{.gnuassembler include=examples/hello-world-attached.hexdump startLine=36 endLine=45}

```

We see that the first byte of our function has changed!


```gnuassembler
00000280  cc 90 90 90 c3 90 90 90  90 c3 00 00 00 00 00 00  |................|
```

Where we previously had a function that did `NOP NOP NOP NOP RET`, we now have the new instruction `0xCC`, which on x86 platforms is the "breakpoint" instruction known as `int3`.

When our enabled check runs now, it will see that the bytes at the start of the function are not a `NOP`, and are `INT3` instead. Now that our function is enabled, our code will allow us to call `probe._fire`.

We can pass up to 6 arguments when firing the probe. The code in `libstapsdt` simply passes every possibly arg count from a variadic list signature using a `switch` statement:

```{.c include=src/ruby-static-tracing/ext/ruby-static-tracing/lib/libstapsdt/src/libstapsdt.c startLine=207 endLine=228}

```

When the address is called, the arguments passed in will be pushed onto the stack for this function call. This is how our probe is able to read arguments - by examining the address space of the caller's stack.

### int3 (0xCC), NOP (0x90) and uprobes

When the probe is fired, the kernel begins its trap handler. We can see this by running a trace of the kernel's trap handler
while we attach our probe:

```
$ bpftrace -e 'kprobe:is_trap_insn { printf("%s\n", kstack) }'
Attaching 1 probe...

        is_trap_insn+1
        install_breakpoint.isra.12+546
        register_for_each_vma+792
        uprobe_apply+109
        trace_uprobe_register+429
        perf_trace_event_init+95
        perf_uprobe_init+189
        perf_uprobe_event_init+65
        perf_try_init_event+165
        perf_event_alloc+1539
        __se_sys_perf_event_open+401
        do_syscall_64+90
        entry_SYSCALL_64_after_hwframe+73
```

We can see that attaching the uprobe via the perf event is what causes the probe to be enabled, and this is visible to the userspace process.

When an enabled probe is fired, the trap handler is called. 

`int3` is a special debugging/breakpoint instruction with opcode `0xCC`. When a uprobe is enabled, it will overwrite the memory at the probe point with this
single-byte instruction, and save the original byte for when execution is resumed. Upon executing this instruction, the uprobe is triggered and
the handle routine is executed. Upon completion of the handler routine, the original assembly is executed.

As we showed above, the address where we place the uprobe is actually in the mapped address space of the generated ELF binary, and a NOP instruction (0x90) is all we are overwriting.

So, in order to check if a tracepoint is enabled, we just check the address of our tracepoint to see if it contains a NOP instruction. If it does,
then the tracepoint isn't enabled. If it doesn't, then a uprobe has placed a 0xCC instruction here, and we know to execute our tracepoint logic.

Upon firing the probe, libstapsdt will actually execute the code at this address, letting the kernel "take the wheel" briefly, to collect the trace data.
This will execute our eBPF program that collects the tracepoint data and buffers it inside the kernel, then hand control back to our userspace ruby process.

![eBPF handler injection from uprobe](./img/instruction-probes-workflow-z1-escaped.png)

Diagram credit [@uprobes-int3-insn].

### USDT read arguments

Here we can see how arguments are pulled off the stack by bpftrace.

Its call to `bcc`'s `bcc_usdt_get_argument` builds up an argument struct:

```{.c include=src/bcc/src/cc/usdt/usdt.cc startLine=527 endLine=548}

```

These functions are implemented using platform-specific assembly to read the arguments off of the stack.

We can see that the special format string for the argument in the ELF notes, eg `8@%rdi`, is parsed to determine
the address to read the argument from:

```{.c include=src/bcc/src/cc/usdt/usdt_args.cc startLine=398 endLine=418}

```

This how each platform is able to parse out the argument notation, to know where and how to pull the data out of
the callstack.
