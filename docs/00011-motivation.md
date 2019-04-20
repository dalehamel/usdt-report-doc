---
title: USDT Tracing report
author: Dale Hamel

---

# Motivation

I started this document with the hope that it would act as a helpful introduction to a number of cool new technologies being developed to enhance system observability on Linux platforms.

With containerization being the dominant paradigm for production environments, workloads have moved from statically scheduled, orderly single-tenant deployments, to multi-tenant swarms of containers.

The rigid order that configuration management systems like Chef, Ansible, Puppet, and Salt brought to DevOps were more akin to orderly armies. Like pieces on a chessboard, they were deployed tactically, with each playing their rigidly defined role. The capabilities of each piece here are described by rigidly defined machine specifications, and mapping a single application to a host image. These systems each brought ways to describe host systems with libraries (cookbooks / manifests, etc), to combine into a single machine image.

Such machines had typically been deployed by specifying a number of replicas for each host, as described through terraform, cloudformation, or other frameworks. As there are many pawns, there are many app servers on the front lines. Load balancers can be thought of as a sort of cavalry, caches as rooks or bishops, and with database serving the role of the vital piece - the king.

This is the orderly world that existed before containerization and distributed schedulers shook things up. Docker, along with other containerization technologies like lxc, rkt, containerd, runc, has shaken things up entirely. The ability to describe host systems that devops tools brought us paved the way for various container building libraries. Rather than needing to describe the role of each piece, we could make each piece adaptable. A single type of piece that can accept any workload definition - one host machine image that understands how to run a single (or many) container images. Suddenly, every piece on the board is a Queen.

Kubernetes, mesos, docker swarm, and other container orchestration environments take this one step further. Rather than the orderly confines of a chessboard, everything is dynamic at runtime through the use of a scheduling engine. The rigid, rule-based nature of a game of chess fails to describe this within the confines of any sort of game theory. Thinking of deployments in terms of swarms of bees becomes the new norm.

The game of chess is easily understood, and while complicated, it is more predictable. This is its strength, and its downfall. The swarm of bees is rapidly adaptable and reacts in realtime. This mirrors the state of observability on these platforms. There are many chess experts, but being good at chess doesn't necessarily overlap with the skillset necessary to understand the hive mind of a bee colony.

As a production systems operators, we must adapt our mindset to this new paradigm. eBPF is a useful tool to help us understand what our colony of bees is doing, and if our hive is thriving.

I hope you enjoy reading it and find the content accessible. I am constantly seeking to improve my writing and communication skills, so if you have suggestions please give me the gift of feedback on any suggestions to help improve accessibility and clarity.

-Dale Hamel
