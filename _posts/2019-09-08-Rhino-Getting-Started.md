---
layout: post
title:  "Rhino: Load Testing Framework"
description:  "Create JUnit-style load and performance tests in Java."
author: Erhan Bagdemir
image:  '/images/03.jpg'
comments: true
keywords: "Java, Load Testing"
category: Testing
featured: true
tags:
- Load Testing
- Performance Testing
- Java
- Rhino
---

Rhino Load and Performance Testing Framework is a sub-project of the Rhino umbrella project and an SDK which 
enables developers to write load and performance tests in JUnit style. With annotation 
based development model, load test developers can provide the framework with metadata required for running tests. The Rhino is developed under Apache 2.0. 


## Creating your first project

You can create Rhino projects by using Rhino Archetype. The Maven Archetype project allows 
developers to create new Rhino performance testing projects from the scratch:

```bash
$ mvn archetype:generate \
  -DarchetypeGroupId=io.ryos.rhino \
  -DarchetypeArtifactId=rhino-archetype \
  -DarchetypeVersion=2.2.1 \
  -DgroupId=com.acme \
  -DartifactId=my-foo-load-tests
```
<br/>
For the groupId, you need to set your project's groupId, that is specific to your project and organization e.g `com.yourcompany.testing` and the 
artifactId is some artifact id used to identify your project e.g `my-test-project`. 
After entering the mvn command above, the project will be created which can be imported in your IDE. 

You may choose to create a Rhino project without using the Rhino archetype. In this case, you can add the Rhino core dependency into your POM file:

```xml
<dependency>
  <groupId>io.ryos.rhino</groupId>
  <artifactId>rhino-core</artifactId>
  <version>1.8.2</version>
</dependency>
```
<br/>
[rhino-hello-world](https://github.com/ryos-io/Rhino/tree/master/rhino-hello-world) located in the project's root, might be a good starting point if you want to play around. 

## Writing your first Simulation with Scenarios

Rhino projects do consist of a main-method to run simulations and simulation 
entities which are annotated with Rhino annotations. An example application might look as follows: 

```java
import io.ryos.rhino.sdk.Simulation;

public class Rhino {

    private static final String PROPS = "classpath:///rhino.properties";
    private static final String SIM_NAME = "Server-Status Simulation";

    public static void main(String ... args) {
        Simulation.create(PROPS, SIM_NAME).start();
    }
}
```
<br/>
`Simulation` is the load testing controller instance which requires a configuration file in the classpath ( therefore `classpath://<absolute path to configuration file>` prefix is important) and the name of the simulation to be run. You can also put the properties file outside of the classpath e.g somewhere on your disk: "file:///home/user/rhino.properties"


The name of the simulation must match the name, set in Simulation annotation so that the Simulation controller can locate the Simulation entity:

```java
@Simulation(name = "Server-Status Simulation")
public class RhinoEntity {

  private static final String TARGET = "http://localhost:8089/api/status";
  private static final String X_REQUEST_ID = "X-Request-Id";
  
  private Client client = ClientBuilder.newClient();

  @Provider(factory = UUIDProvider.class)
  private UUIDProvider uuidProvider;

  @Scenario(name = "Health")
  public void performHealth(Measurement measurement) {
    var response = client
            .target(TARGET)
            .request()
            .header(X_REQUEST_ID, "Rhino-" + uuidProvider.take())
            .get();

    measurement.measure("Health API Call", String.valueOf(response.getStatus()));
  }
}
```
<br/>
In the example above, we mark the simulation entity with `@Simulation` annotation with a unique name attribute. The simulation entity is a container for the scenario methods which are run by the Rhino runtime and annotated with @Scenario annotation. Each scenario method must have a name which is used in performance measurements and reporting, so the scenario method takes the name "Health" for healthcheck test. The scenario methods will take `Measurement instance to let load testing developers add measurement points. In the example, we measure the time elapsed between the method execution and http request completion. A scenario method might contain multiple measurement points. 

Once you start the Rhino main method, the framework will start to call the performHealth- method repeatedly and after each call, it will measure the time elapsed. 

Alternatively, you may choose the reactive style and implements a [Load DSL](https://github.com/ryos-io/Rhino/wiki/Reactive-Tests-and-Load-DSL):

```java
@Simulation(name = "Reactive Sleep Test")
@Runner(clazz = ReactiveHttpSimulationRunner.class)
public class ReactiveSleepTestSimulation {

  @Dsl(name = "Health")
  public LoadDsl performHealth() {
    return Start
        .dsl()
        .run(http("Health API Call")
            .header(c -> from(X_REQUEST_ID, "Rhino-" + UUID.randomUUID().toString()))
            .endpoint(TARGET)
            .get()
            .saveTo("result"));
  }
}
```
<br/>
To enable the DSL mode, you need to add `ReactiveHttpSimulationRunner` to your Simulation. In this mode, the load testing developers describe how a load test is to be run instead of providing the implementation what to run. 

The project is in its early development stage. Please feel free to join the community, use Rhino in your load test projects and create issues on [Github](https://github.com/ryos-io/Rhino/). We appreciate your contributions on the project.
