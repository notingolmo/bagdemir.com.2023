---
layout: post
title: "Dockerized Java Enterprise"
description: "Docker has definitely changed the developer's culture in Java Enterprise."
date: 2018-07-07 16:41:50
comments: true
keywords: "Java, Docker"
image:  '/images/09.jpg'
category: Cloud Engineering
tags:
- Java
- Docker
---

Since Docker containers became the new virtualization layer between the operating system and the applications, Java engineers whose job was to develop web services in the SOA epoch, had to adapt themselves to work with Docker containers, suddenly. But, how do containers change developer's culture? 

As engineers in the Java enterprise field were building web services, the artifacts they created were EAR, stands for enterprise application archive as the service contract they trusted was WSDL. Once the web service was ready to ship, the artifact had been handed over to the operations, the folks rolled out it onto some application server or simple servlet container like Tomcat in production environment back in those days. The tasks, the software engineers readily overlook, for instance, configuring the JVM, Configuration Management, Security, Compliance, etc. were mostly outsourced to the operations. Since begin of the container era, however, the boundaries of responsibilities between operations and engineering has been changed because the new deployable artifact became a Docker container instead of Java archive. Thus, Java developers inevitably began to get involved in such topics relate to the outside of the Java application, as well. Hence, they became more backend software engineers rather than being “just” a Java enterprise developer - even those who never entered shell command in the command-line in their lives.

Today, containers are everywhere. We love to create and distribute our web services as Docker images, install deamonized services, that are running as containers in the background, run tests against our REST services which are packaged as Docker images in our integration environment, even spin up the whole back-end landscape on our computer by employing containers so that we can develop, test and debug our applications and also to understand the stubborn issues occurring most likely in association with other components.

But, what is the deal with containers?

* Containers are self-contained. The images include everything that an application needs. For instance, if we build a web service in Java ecosystem, we can install the JVM in the Docker image so that the host machine doesn’t even need to have Java installed on it. We can distribute that docker image with all its dependencies. 

* Containers are immutable. Once we bake a new image, it remains unchangeable. If we need to add new features, a new image is to be created. This treat of docker images makes the behaviour of a container more predictable. 

* Containers are runnable. You can provide entrypoints and describe what to run within a container whenever we run it. This is useful, because, for instance, you might want to run an executable JAR file or a servlet container while starting a container.  In that sense, there is no difference whether you run the JAR on your developer machine directly, or within a container. If you use container, by the way, 

* Containers are light-weight. In contrary to hardware-level virtualisation, software level containerisation allows containers to share operating system resources. They are small and starting a container takes a few seconds whereas to start a virtual machine much more longer.

* And, with container orchestration the heterogeneous infrastructure becomes a continuum of resources, that containers might leverage. 

I think, the obvious reason why containers are broadly adopted by software engineers is basically being tailored to share and ready to run. Before container era, if you started off a backend project on your developer machine which were very likely to depend on some other services and components like databases, engineers had needed to install and configure these dependencies to test the integration. On the other hand, today, in the world of containers you can easily fetch a containerised database, search engine or whatever you need from the Internet and run it immediately on your machine without installing it. How easy is that? 

Once you are ready to deploy a service, you can distribute it as Docker images. The container orchestration platforms like Mesos, are de facto standards, empowering the production systems, that provide solid infrastructure in order to run Docker containers by hiding heterogeneity of underlying hardware.  

From the Java Enterprise engineer’s view, containers are inevitable today. On your developer machine or in production, while developing software, or deploying it, you will come across Docker images and containers everywhere. There has been growing community around Docker containers. So, there are lots of Docker images around the Internet. If you ever need some backend components while building your services, like databases, batch processors, search engines, whatever you need you can leverage the power of community driven Docker images - as well as the official ones.
