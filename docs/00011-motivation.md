## Motivation

I started this document with the hope that it would act as a helpful introduction to a number of cool new technologies being developed to enhance system observability on Linux platforms.
With containerization being the dominant paradigm for production environments, workloads have moved from statically scheduled, orderly single-tenant deployments, to multi-tenant swarms of containers.

As a Production Systems Operator, eBPF has proven itself to be is a useful tool to help reliably give insight into deployed code serving live traffic where otherwise it would be difficult to see what an application is doing without compromising performance and bogging down the user experience of a live system, or worse, compromising and crashing it entirely.

The relative ease of writing language-specific bindings, even for dynamically evaluated languages, I think has bent the learning curve to the point that it is within reach, or has become a "lower hanging fruit" than it was before. While much work is ongoing for distributed tracing, I see this to be complementary to this type of userspace system tracing. Distributed tracing can show the interactions between apps, and USDT tracing and uprobes can help to drill down into individual systems.

I hope you enjoy reading this report and find the content accessible. I am constantly seeking to improve my writing and communication skills, so if you have suggestions please give me the gift of feedback on any suggestions to help improve accessibility and clarity.

-Dale Hamel
