---
layout: post
title: "Mesos: A Datacenter OS"
description: "The need of orchestration of heterogeneous infrastructure, non-unified characteristics of the hardware on different server systems and fluctuating resource needs of software and the challenges in resource utilisation, urges us to rethink, how to deal with the vast amount of servers in our datacenters."
date: 2016-01-10 16:41:50
comments: true
keywords: "Mesos, Infrastructure"
category: Cloud Engineering
tags:
- Mesos
- Infrastructure
---

{:title "Mesos: A Datacenter OS"
 :layout :post
 :tags  ["Mesos", "Infrastructure", "Deployment"]
 :toc true}



The need of orchestration of heterogeneous infrastructure, non-unified characteristics of the hardware on different server systems and fluctuating resource needs of software and the challenges in resource utilisation, urges us to rethink, how to deal with the vast amount of servers in our datacenters. The idea, Datacenter as a Computer is the driving motivation behind the frameworks like Mesos. Thinking of the datacenter as a huge imaginary computer, a.k.a Warehouse-scale Computer, WSC [0], while providing a unified API to the outside and hiding the internal complexity of the infrastructure from applications, the requirements like resource sharing, process scheduling and package management converge to those which we already know from conventional computers and operating systems. Apache Mesos, as a Datacenter operating system, copes with the same problems, but in cluster-scale.

## Static Partitioning

Static partitioning is a kind of design pattern for system architecture. We always tend to build clusters of the same type of services running on a group of servers. It is 1-1 relationship between the server and the service itself. We like building clusters, since it is easier to understand the workload and manage the resources available on them. If you consider that different services may have different resource demands and workload characteristics, for instance, an data analysis tasks may run twice in a day whereas a web service should be accessible 7/24, the problem with the resource management gets more tangled.

If you’re working in the cloud, you still need to manage clusters or stacks with some automation tools (like CloudFormation on AWS), though, but the mindset problem still remains. You have to make precise predictions about the instance types, otherwise the resource utilisation will not be that efficient and misprediction ends up with idling instances which in turn cost money. However, if you think about conventional processors and operating systems, we don’t clusterize their processor cores while running our applications. It wouldn’t scale. Instead, a single core can deal with multiple applications – in a time-sharing manner. We need some sort of layer between the hardware and our services, i.e an operating system for our WSC to manage resources in distributed systems.

Today, we are working with Docker containers. We dockerize our applications as deployment artifacts. However, the question is still, how many of these containers would fit on a single machine and how do we achieve sharing resources efficiently among all these containers in our datacenter ? One docker container on a single server wouldn’t scale. We need still some orchestration tool for our containers.

The resource management is indeed not the only problem with the static partitioning. Scaling is an another challenge. Think about it; if you want to realign a cluster or resize it by shrinking or extending with new hardware. This is bound to a tedious undeploy / redeploy effort [1]. You first need detach some servers that you want to remove from the current cluster and prepare them by undeploying the applications, and redeploying the new ones for the new cluster. On the other hand, if we go back to our imaginary big computer analogy, we don’t reinstall our applications, if we add or remove a new RAM module, or a newer CPU [2].

In addition to all these requirements mentioned above, the OS for the Datacenter must be able to schedule the tasks, which are going to run on servers, while negotiating with the resource agents about available resources in the cluster. If currently no resource is available, tasks should be queued and as soon as some resources become available, they should be run according to their priorities.

## Conclusion

Mesos as an operating system, while addressing these problems, enables cluster-wide resource sharing among all processes. It employs Docker containers to fulfil the tasks of a package manager. It can pull Docker containers from the DockerHub or from an another Docker respository. As a container orchestration tool, it can manage available resources between the containers in a cluster. Mesos leverages, LXC, Linux Containers interface as Docker does, to provide an operating system level virtualisation for process isolation, if you don’t use Docker containers.

Moreover, Apache Mesos provides an unified API between the software and the infrastructure just as an operating system kernel does. No matter what kind of hardware under Mesos layer do exist, we still use the same procedures to create, run, stop and kill our tasks. Additionally, Scheduler/Executor components of a Mesos Framework incorporation with Mesos’ allocation modules, implements the task scheduling feature. Because of all these evidences, it is not wrong to think Apache Mesos as an Operating System for your Datacenter.

Erhan

[0] [The Datacenter as a Computer – Computer Science Division](https://www.cs.berkeley.edu/~rxin/db-papers/WarehouseScaleComputing.pdf)

[1] Luckily, you can automize this process by writing scripts, using tools like Chef, Puppet, etc. However, you may still need a toolchain and some engineers to program that pipeline for different applications e.g by writing Chef cookbooks. You also have to count the Chef/Puppet run time in in your total time cost calculation, till a service become ready to receive the production load.

[2] If the applications are not that low-level and written to run on a specific hardware.
