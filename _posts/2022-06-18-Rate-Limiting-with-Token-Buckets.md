---
layout: post
title: "Rate Limiting with Token Buckets"
description: "In services landscape, rate limiting is not only a requirement to protect the available resources from getting exhausted and failing in the end, but it is also vital for attaining fair resource sharing among your users and also application clients."
date: 2022-06-01 08:41:50
comments: true
keywords: "Rate Limiting, Resilience"
category: Cloud Engineering
image:  '/images/20.jpg'
tags:
- Cloud Computing
- Rate Limiting
- Resilience
---

In services landscape, rate limiting is not only a requirement to protect the available resources from getting exhausted and failing in the end, but it is also vital for attaining fair resource sharing among your users and also application clients. Sooner or later, as the business grows, you may want to implement a throttling mechanism eventually to slow down noisy neighbors to keep the throughput at the highest level while fulfilling latency requirements. In this article, we together will throw a quick look at one of the prevalent rate-limiting strategies in the application layer by example, which is the token bucket.

> In this article I will demonstrate an example service implementation by using Spring Boot and Bucket4j. The article contains only the core components to keep it simple. The example project, we will walk through below, can be seen >[here](https://github.com/bagdemir/bucket4j-spring-redis-example).

### Overview

A token bucket is a container of tokens of which capacity or budget is limited for a certain amount of time. For incoming requests, tokens will be taken out of the bucket while refilling it again after a predefined period. If the tokens in bucket are exhausted, the service rejects subsequent requests so long as the bucket is refilled and has capacity again. To have throughput under control, it provides a limited number of tokens for a period which prevents users from surpassing limits of available resources what consequently might lead up to increased latency in service.
You may have noticed that a token bucket algorithm is quite similar to the fixed window throttling mechanism. Indeed, the difference between the token bucket and a fixed window rate limiter is slight. A fixed window rate limiter allows a strict throughput within a predefined period. However, token buckets also will enable you to control how fast a bucket can be refilled. The token bucket will act as a fixed window throttler if you keep the same fixed refill rate. One thing that neither a token bucket nor a fixed window rate-limiter cannot prevent is the burst (In a fixed-window rate limiter, if the request-burst overlaps the ending and beginning of two windows, the effect will even look worse. The sliding window rate limiter improves weakness of the fixed-window rate limiter by taking the previous window's state into account.). Nevertheless, you can convert a token bucket into a leaky bucket while adding a fine-grained throughput controller, e.g., a maximum of one hundred requests per second whereas the bucket's capacity has control over a more extended period.

<img src="/images/token_bucket.jpeg">

### Distributed Token Bucket with Bucket4j

In the following example, I use Spring Boot framework and Redis to demonstrate a realistic cloud service implementation. The bucket state will be maintained in a database so that application instances can access this shared state and evaluate it every time as a request is being handled in the container. If your use case doesn't require persistence, for example, what you need is to protect resource exhaustion on a single instance, you may want to omit the database option. However, suppose your use case requires tracking overall resource usage and implementing an enforcement mechanism, e.g., a quota 
management instance. In that case, you should evaluate persistence options to store the bucket state.

<img src="/images/token_bucket2.jpeg">

### Implementation as a Spring Boot Service

Rate limiting should preferably operate before the business logic layer picks up the request to keep the domain-relevant implementation simple and lean. In Spring-based applications, it can be implemented, for instance, as a handler interceptor, which pre-and-post processes the requests. The interceptor verifies the access limits by delegating the call to the rate limiter component. Once the limit is exceeded, the rate limiter and the interceptor, respectively, reject subsequent requests with HTTP 429 "Too many requests" immediately - and it is also a good practice to include a Retry-After header to let clients know when they should come back for the next request:

```java
public boolean preHandle(
    HttpServletRequest request,
    HttpServletResponse response,
    Object handler) {

    Map<String, String> pathVars = (Map<String, String>)
       request.getAttribute(HandlerMapping.URI_TEMPLATE_VARIABLES_ATTRIBUTE);

    if (!rateLimiter.tryAccess(pathVars.get(USER_ID))) {
        response.setStatus(TOO_MANY_REQUEST);
        response.setHeader(RETRY_AFTER, IN_300_SECS);
        return false;
    }
    return true;
}
```
<br/>
The RateLimiter service below provides its clients with a "tryAccess()" method, of which call queries the underlying bucket with a key. Since we maintain a token bucket per key, e.g., in our scenario, a user identifier, we need to pass it to the proxy manager so that the corresponding token bucket can be looked up in the database:

```java
public class RateLimiter {
    private final RedissonBasedProxyManager redissonBasedProxyManager;
    private final BucketConfiguration bucketConfiguration;

    public RateLimiter(RedissonBasedProxyManager redissonBasedProxyManager,
                       BucketConfiguration bucketConfiguration) {
        this.redissonBasedProxyManager = redissonBasedProxyManager;
        this.bucketConfiguration = bucketConfiguration;
    }

    public boolean tryAccess(String key) {
        return redissonBasedProxyManager
                .builder()
                .build(key, bucketConfiguration)
                .tryConsume(1);
    }
}
```
<br/>
RedissonBasedProxyManager ➋ is the proxy implementation for Redis-backed token buckets, that is provided by Bucket4j. It will store by BucketConfiguration ➌ configured token bucket's state in Redis. Both components are Spring Beans and injected to RateLimiter, which is also managed by IoC container:

```java
@EnableWebMvc
@Configuration
@EnableCaching
public class AppConfig implements WebMvcConfigurer {

    @Bean
    public RateLimiter rateLimiter() throws IOException {
        return new RateLimiter(proxyManager(), bucketConfiguration());
    }

    @Bean(destroyMethod = "shutdown")
    public ConnectionManager redissonConnectionManager() throws IOException {
        File resourceURL = ResourceUtils.getFile("classpath:redis.yml");
        Config config = Config.fromYAML(resourceURL);
        return ConfigSupport.createConnectionManager(config);
    }

    @Bean
    public RedissonBasedProxyManager proxyManager() throws IOException {
        CommandSyncService commandSyncService = 
            new CommandSyncService(redissonConnectionManager());
        return new RedissonBasedProxyManager(commandSyncService,
                ClientSideConfig.getDefault(),
                Duration.ofMinutes(10));
    }

    @Bean
    public BucketConfiguration bucketConfiguration() {
        return BucketConfiguration
            .builder()
            .addLimit(Bandwidth.simple(2, Duration.ofSeconds(1)).withInitialTokens(2))
            .build();
    }
}
```
<br/>
Above, the bucket configuration instantiates a Bucket4j token bucket configuration, which has the bandwidth of two tokens, and it is refilled every two seconds while being consumed by one token with every request.

### Conclusion

Even though the general approach to implementing a bucket token is by reducing buckets by one token for each request, your use case may require removing more than one token depending on API group, for instance, to apply stricter limits to requests on resource-consuming APIs. However, this might introduce more sophisticated policy control requirements while considering resource requirements of different APIs, different types of user contracts, central authority of bucket configurations, etc. So, depending on the problem you are trying to solve, some contract-based quota management vs. throttling to protect server-side resources, the architecture can be enhanced with additional components.
Token bucket is quite simple but handy algorithm that can be used to implement for throttling requests in web services to protect server-side resources while enabling a fair resource sharing by limiting the noisy neighbors. With the F/OSS frameworks like Bucket4j, it is also quite straightforward to integrate with existing service architecture. You can also leverage it to implement e.g. quota management according to some license-based policies, which are incorporated with your business requirements. One thing that it cannot prevent is the request burst. Yet you can streamline the implementation with additional limitation e.g. maximum request per time unit, what would then behave like a leaky bucket in a sense.