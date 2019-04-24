# Use in Local Development Environments

## Using virtualization

If your development environment already runs on top of a hypervisor, such as `Docker for Mac` or `Docker for Windows`. However, at present these do not currently work with bpftrace, as the kernel is too old and doesn't support the necessary features. You can (and I have) built an updated kernel using linuxkit [@linuxkit], but while this does work it breaks the filesharing protocols used for bind-mounting with at least `Docker for Mac`.

If `WSL` comes with a new enough kernel or can load custom kernels, it may be able to play a similar role to `xhyve` [@xhyve] or hyperkit [@hyperkit], but I have not tested against a Windows development environment or `WSL`.

Vagrant is another option, and a Vagrantfile is included as a reference implementation for how to bootstrap a minimal-enough VM to get the included Dockerfile to run.

The long and short of this approach is that it is good for if you are running your development application or dependencies inside of a linux VM, they can be traced with bpftrace provided that the kernel is new enough.

## dtrace

Some environments may use a Linux VM, such as Docker for Mac, Docker For Windows, or Railgun [@railgun-overview], but run the actual application on the host OS, to provide a more native development experience.

In these cases, since the application isn't running inside of Linux, they cannot be probed with `bpftrace`. Luckily, OS X and Darwin include `dtrace`, and it can be used out-of-the-box, for all of the functionality outlined here. For the discussion here, the focus will be mostly on `dtrace` on OS X.

When you run dtrace, it will complain about system integrity protection (SIP), which is an important security feature of OS X. Luckily, it doesn't get in the way of how we implement probes here so the warning can be ignored.

You do, still, need to run dtrace as root, so have your `sudo` password ready or `setuid` the `dtrace` binary, as we do for our integration tests with a copy of the system dtrace binary.

dtrace can run commands specified by a string with the `-n` flag, or run script files (conventionally ending in `.dt`), with the `-s` flag.

[@dtrace-osx-manpage]

Many simple dtrace scripts can be easily converted to bpftrace scripts see this cheatsheet [@bgregg-dtrace-for-linux], and vice-versa.

## Listing tracepoints

To list tracepoints that you can trace:

On Darwin/OSX:

```
dtrace -l -P "${PROVIDER}${PID}"
```

## Simple hello world

Recall from earlier, when we run `helloworld.rb`, it will loop and print:

```
Not enabled
Not enabled
Not enabled
```

One line about every second. Not very interesting, right?

With dtrace:

```
dtrace -q -n 'global*:::hello_nsec
             { printf("%lld %s\n", arg0, copyinstr(arg1)) }'
```

Or, with dtrace and a script:

```
dtrace -q -s helloworld.dt
```

`helloworld.dt`:
```{.awk include=examples/helloworld.dt}
```

## Aggregation functions

dtrace has equivalent support to bpftrace for generating both linear and log2 histograms. 

Recall from the example using `randist.rb` above:

The example should fire out random integers between 0 and 100. We'll see how random it actually is with a linear histogram,
bucketing the results into steps of 10:

```
dtrace -q -n 'global*:::randist { @ = lquantize(arg0, 0, 100, 10) }'
```

```
 value  ------------- Distribution ------------- count    
   < 0 |                                         0        
     0 |@@@@                                     145456   
    10 |@@@@                                     145094   
    20 |@@@@                                     145901   
    30 |@@@@                                     145617   
    40 |@@@@                                     145792   
    50 |@@@@                                     145086   
    60 |@@@@                                     146287   
    70 |@@@@                                     146041   
    80 |@@@@                                     145331   
    90 |@@@@                                     145217   
>= 100 |                                         0        

```

There are other aggregation functions [@dtrace-guide-aggregations], similar to those offered by `bpftrace`.

## Latency distributions

Recall the `nsec` example from earlier with `bpftrace`.

// FIXME add dtrace output for this example
