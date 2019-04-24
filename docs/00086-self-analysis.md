# Self-analysis

Using bpftrace, we can approximate the overhead of getting the current monotonic time. By examining the C code in ruby, we can see that 
`Process.clock_gettime(Process::CLOCK_MONOTONIC)` is merely a [wrapper around the libc function clock_gettime](https://github.com/ruby/ruby/blob/trunk/process.c#L7882-L7892).

Attaching to a Pry process and calling this function, we can get the nanosecond latency of obtaining this timing value from libc:

```
bpftrace -e 'uprobe:/lib64/libc.so.6:clock_gettime /pid == 16138/
             { @start[tid] = nsecs }
             uretprobe:/lib64/libc.so.6:clock_gettime /@start [tid]
             {
               $latns = (nsecs - @start[tid]);
               printf("%d\n", $latns);
               delete(@start[tid]);
             }'
Attaching 2 probes...
11853
5381
5440
4624
3263
```

These are nanosecond values, which correspond to values between 0.005381 and 0.011853 ms. So, getting the before and after time adds on the order of about one hundredth of a millisecond of time spend in the thread.

This means that it would take about one hundred probed methods to add one millisecond to a service an application request. If requests are close to 100ms to begin with, this should make the overhead of tracing nearly negligible.

we must also measure the speed of checking if a probe is enabled to get the full picture, as well as any other in-line logic that is performed.
