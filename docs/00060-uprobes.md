## int3 (0xCC), NOP (0x90) and uprobes

The other bit of magic here is that the probe automatically becomes enabled when it is attached to.

This is pretty hard to track down, as it actually happening inside the kernel when the probe is enabled:

```
 bpftrace -e 'kprobe:is_trap_insn { printf("%s\n", kstack) }'
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

So long as all calls to fire a probe are wrapped in an (extremely fast) is-enabled check, they should return quickly if disabled.

The above processing is also only done when a probe is enabled / disabled, meaning that it is not overhead that is incurred each time a probe is actually fired.

When a probe is enabled, `int3` instruction is used to cause the probe to be executed:

![diagram](https://dev.framing.life/assets/images/post/kernel-and-user-probes-magic/instruction-probes-workflow-z1-escaped.svg)

`int3` is a special debugging/breakpoint instruction with opcode `0xCC`. When a uprobe is enabled, it will overwrite the memory at the probe point with this
single-byte instruction, and save the original byte for when execution is resumed. Upon executing this instruction, the uprobe is triggered and
the handle routine is executed. Upon completion of the handler routine, the original assembly is executed.

In libstapsdt, the address where we place the uprobe is actually in the generated ELF binary, and a NOP instruction (0x90) is all we are overwriting.

So, in order to check if a tracepoint is enabled, we just check the address of our tracepoint to see if it contains a NOP instruction. If it does,
then the tracepoint isn't enabled. If it doesn't, then a uprobe has placed a 0xCC instruction here, and we know to execute our tracepoint logic.

Upon firing the probe, libstapsdt will actually execute the code at this address, letting the kernel "take the wheel" briefly, to collect the trace data.
This will execute our eBPF program that collects the tracepoint data and buffers it inside the kernel, then hand control back to our userspace ruby process.
