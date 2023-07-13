---
layout: post
title:  "Matrix URIs, their semantics and usage in Java RESTful Services"
author: erhan
image:  '/images/19.jpg'
comments: true
keywords: "HTTP, REST"
category: Cloud Engineering
tags:
- W3
- JAX-RS
---


Matrix URIs, as *[Tim Berners-Lee](https://www.w3.org/People/Berners-Lee/)* called them in his personal *[design draft](https://www.w3.org/DesignIssues/MatrixURIs.html)* back then in 1996, or matrix parameters and sometimes path parameters, have been broadly adopted by applications in web services landscape, today. Their syntax is specified in the *[RFC3986](https://tools.ietf.org/html/rfc3986#section-3.3)* "Uniform Resource Identifier (URI): Generic Syntax" in section 3.3 while reserving the usage of “;” and “=“ for the applications which prefer to apply a list of delimited qualifiers to the path segments. The original idea behind the matrix parameters is to enhance the hierarchical structure of URIs, that allows applications to navigate a tree structure with ease, with another space as a matrix - that is where matrix term comes from:

> Just as the slash separated set of elements is useful for representing a tree, so a set of names and equally significant parameter can represent a space more like a (possible sparse) matrix.

Although the RFC3986 does touch upon matrix parameters as sub-components of path segments and the delimiters “;” and “=“ are defined as “reserved” characters, the RFC is reluctant to call them “matrix” parameters. The reason is, matrix URIs were still in proposal state as the RFC3986 was published and its status has not been changed since then. In this blog, we will take a closer look at a few examples of matrix URLs and how they are incorporated in higher-level concepts like Java API for RESTful Services. Let us begin with a simple example:

```shell
/foo;version=1/manifest
/foo;version=2/manifest
```
<br/>
According to the RFC, the semantics of matrix URIs - and how they qualify a particular path segment within a hierarchical path is left to the implementation. In the example above, the path down to the manifest file is branching depending on the version parameter. Identification of the resource, manifest, might vary with different values of version parameter, but it might also stay the same. It is up to the application.

Matrix URIs gain inevitably complexity with the number of parameters, they define,

![matrix_parameter](https://user-images.githubusercontent.com/1160613/97791717-ae3ab880-1bd5-11eb-886e-3529d38b091e.jpg)

this time, each path segment has its own list of qualifying matrix parameter, extending the dimension of the hierarchical system. The additional vector might be compelling for creators of new specifications and implementators thereof with the conceptual building-blocks of a higher-layer domain, that relies on matrix URIs. One good example for that higher-level domain is the JAX-RS specification, that is Java API for RESTful web services and ```java @MatrixParam ``` annotation, that makes matrix parameters first-class entities. In the following example, JAX RS' ``` java @MatrixParam ``` annotation is used to extract the value of a matrix parameter from URIs: 

```java
@Service
@Path("/")
public class MatrixResource {

  @GET
  @Path("/status/ping")
  @Produces("text/plain")
  public String ping(@MatrixParam("name") String name) {
    return String.format("matrix variable name=%s", name);
  }
}

``` 
<br/>
The resource handler method ```java ping() ``` accepts the requests targetting the /status/ping endpoint while declaring a matrix parameter "name" in the example above. If you you send an HTTP GET request to the /status/ping endpoint, the response will be: 

```shell 
➜ curl -X GET http://localhost:8080/status/ping
matrix parameter name=null
```
<br/>
if no matrix parameter is provided, the value is null, as expected. Another request with a matrix parameter ;name=bar,

```shell
➜ curl -X GET 'http://localhost:8080/status/ping;name=bar'
matrix parameter name=bar
```
<br/>
the matrix param has the value "bar". But, in the following example the value of the matrix parameter will be *null*, that might be confusing:

```shell 
➜ curl -X GET 'http://localhost:8080/status;name=bar/ping'
matrix parameter name=null
```
<br/>
The reason for this is, that the ``` java @MatrixParam ``` annotation "refers to a name of a matrix parameter that resides in the last matched path segment of the Path-annotated Java structure that injects the value of the matrix parameter", as JEE/EE4J JAX-RS API outlines. The request handler equipped with ``` @MatrixParam ``` is not capable to resolve the matrix parameter of intermediate path segments within the same request handler. This would make the JAX-RS specification look congruent with the RFC-3986. Nevertheless, the JAX-RS implementations remove this gap by opening up the access to matrix parameters via PathSegments: 

```java
@Service
@Path("/")
public class MatrixResource {

  @GET
  @Path("/{status}/ping")
  @Produces("text/plain")
  public String ping(@PathParam("status") PathSegment status) {
    MultivaluedMap<String, String> matrixParameters = status.getMatrixParameters();
    String nameMatrixFromStatus = matrixParameters.getFirst("name");
    return String.format("matrix variable name=%s", nameMatrixFromStatus);
  }
}
```
<br/>
this time, the value of the matrix parameter is gathered from the PathSegment instance, that is defined with the path template {status}. Spring developers might have noticed this gap, because Spring's non-JAX-RS-conform annotations solve this problem via partial binding:

```java
@RestController
public class MatrixResource {

  @RequestMapping(value="/{status}/ping", method=RequestMethod.GET)
  public String pong(
      @PathVariable("status") String status,
      @MatrixVariable(name="name", pathVar="status", required=false) String name) {
    return String.format("matrix variable name=%s", name);
  }
}
``` 
<br/>
In Spring Boot, the "scope" of the matrix variable can be defined with "pathVar" attribute, explicitly, in contrast to JAX-RS standard annotations [See Note 1]. Still, this is a very good example for limitations of Java annotations if they are used to describe slightly complex structures. The idea of injecting data into class fields, constructors and method parameters is common in Java stack and has its charm, but as data structures are getting more dimensions like matrix URIs, specifications using annotations will be clumsy. 


One might ask, "why do not we simply use query parameters instead of matrix parameters?". Query parameters apply to the entire path. The URL with matrix parameters can be rewritten as follows: 

```shell 
/mylib;version=3/manifest;version=2/?format=json
/mylib/manifest/?format=json&mylib_version=3&manifest_version=2
```
<br/>
The URI with query parameters has less clarity and the query parameters need additional information for namespacing so as to resolve the ambiguity. 

### Conclusion

Although the matrix URIs were just a design idea from Tim-Bernes Lee, they are widely adopted in web services landscape - especially web services in RESTful fashion. The frameworks implementing the JAX-RS does support matrix parameters, albeit their API specification might not look congruent with the original idea, but implementations thereof e.g Jersey enable full access to matrix parameters in arbitrary path segments. Spring Boot variant does equip non-JAX-RS ``` @MatrixVariable``` annotation with additional attributes which allows to define the context of matrix variable.  


### References

1. https://www.w3.org/DesignIssues/MatrixURIs.html, Tim Berners-Lee
2. https://stackoverflow.com/questions/2048121/url-matrix-parameters-vs-query-parameters
3. https://jakarta.ee/specifications/restful-ws/3.0/restful-ws-spec-3.0-M1.pdf
4. https://tools.ietf.org/html/rfc3986#section-3.3
5. https://forum.raml.org/t/rfc3986-matrix-variables/73
6. https://jakarta.ee/specifications/restful-ws/3.0/restful-ws-spec-3.0-M1.pdf [PDF]

### Notes:

1. The matrix variables are needed to be activated in Spring Boot application: 

```java
@Configuration
public class MatrixConfig implements WebMvcConfigurer {
  @Override
  public void configurePathMatch(PathMatchConfigurer configurer) {
    UrlPathHelper urlPathHelper = new UrlPathHelper();
    urlPathHelper.setRemoveSemicolonContent(false);
    configurer.setUrlPathHelper(urlPathHelper);
  }
}
```

<br/>
<div style="font-size:9px; font-color:#EFEFEF; ">Rev 1.0 1.Nov 2020</div>
