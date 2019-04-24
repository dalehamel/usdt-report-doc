# Use in CI environments

// FIXME fill this out more

To use `bpftrace` and USDT in a linux CI environment, it will need to run as a Privileged container, or a container with near-root privileges.

This can be managed more safely if the `bpftrace` container is scoped back as much as possible.

One possible implementation would be to set up a bpftrace hook-points into the CI script, where bpftrace would be called to check output of a particular probe.

This would allow for sanity checking without the need for prints littered about.

## Call stenography

Tools such as rotoscope [@rotoscope-github] exist to trace method invocations in CI environments.

The built-in Ruby `USDT` probes can do this already, allowing for tracing of methods to be done outside of the ruby VM flow altogether.

A trivial `bpftrace` script can be written to log all method invocations in CI, and be used to help find dead code in CI.

## Memory testing / analysis

Probes that use `ObjectSpace` can test for memory leaks by ensuring that unused objects are cleaned up when GC is called,
and to try and catch objects that may never be released.

## Integration testing

Integration tests can use `bpftrace` to verify that logic is executed, check expected parameters, 


## Performance testing

profile against a synthetic workloads test to prevent against AppDex [@appdex] regressions, in CI or Production
