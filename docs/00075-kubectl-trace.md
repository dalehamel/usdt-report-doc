# kubectl-trace

// FIXME add citation for kubectl-trace crew

For production applications, `kubectl-trace` offers a convenient way to tap into our
USDT tracepoints in production.

`kubectl-trace` will create a new kubernetes job, with a pod that runs bpftrace with
the arguments provided by the user. 

We can use `kubectl-trace` to apply a local bpftrace script or expression to bpftrace
instance running alongside our application. This allows for very easy, targetted tracing
in production.

// FIXME have an example of tracing a web app
