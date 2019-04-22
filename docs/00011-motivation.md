## Motivation

I started this document with the hope that it would act as a helpful introduction to a number of cool new technologies being developed to enhance system observability on Linux platforms.
With containerization being the dominant paradigm for production environments, workloads have moved from statically scheduled, orderly single-tenant deployments, to multi-tenant swarms of containers. Where I used to think of server deployments more like a game of chess, I now find that a swarm of bees is a better analogy.

As Production Systems Operators, we must adapt our mindset to this new paradigm. eBPF is a useful tool to help us understand what our colony of bees is doing, and if our hive is thriving. In the way that a farmer selectively checks their crop for quality, tracepoints can be used to take diagnostics on a subset of the "bees" in our production hive. I hope that this report will convince the reader of utility of such tracepoints. If this is acknowledged and proves true, then I hope this report serves to support a new paradigm, and that such tracepoints become ubiquitous in our application's software.

The relative ease of writing language-specific bindings, even for dynamically evaluated languages, I think has bent the learning curve to the point that it is within reach, or has become a "lower hanging fruit" than it was before. While much work is ongoing for distributed tracing, which also aims to help us understand our "bee" clusters, I see distributed tracing to be complementary to this type of userspace system tracing. Distributed tracing can show the interactions between apps, and USDT tracing can help to drill down into individual systems.

I hope you enjoy reading this report and find the content accessible. I am constantly seeking to improve my writing and communication skills, so if you have suggestions please give me the gift of feedback on any suggestions to help improve accessibility and clarity.

-Dale Hamel
