---
layout: post
title: "Powermocking and OOP"
description: "Encapsulation helps us to define boundaries of data and behavior within a class, though there are mocking frameworks which bend the rules of this protection."
date: 2017-04-09 16:41:50
comments: true
keywords: "Java, Testing, Mocking"
image:  '/images/08.jpg'
category: Testing
tags:
- Java
- Testing
- Mocking
---

Encapsulation helps us to define boundaries of data and behavior within a class, though there are mocking frameworks which bend the rules of this protection. But, if you consider, is it all right to drill down through this protection layer by leveraging the reflection API and mock private methods even within unit tests? An idealistic object oriented programmer would claim that it is basically a violation against object oriented programming principles. In my opinion, it depends on the context and situation in which you attempt to violate the rules of the paradigm at the first sight. However, the mocking frameworks like Powermock might save the day, if you need to mock the call to a static factory method, of which factory is required to be set up first in order to create an instance.  

Let's think about the following scenario:
{% highlight scala %}
public class PizzaFactory {
       private final int season; // 1 => Winter, 2 => Spring, 3 => Summer, ...
       public PizzaFactory() {
       	      this.season = getCurrentSeason(System.getCurrentTimeInMillis());
       }

       public static Pizza makePizza() {
       	      return new Pizza(season);
       }
}
{% endhighlight %}

The `PizzaFactory` is a typical example of maintaining the internal state and its hurdles. A lot of supporting arguments made in favor of static/private method mocking mostly give such examples and the easiest way to make progress in writing tests for the clients of `makePizza` factory method is to mock the static method instead of fixing the design problem. There might be lots of poorly designed 3rd party libraries such that you can't even refactor the source code. The question is here however if you can live without employing them. If the library code is located in your own code base, then at least you have still the chance to get things right.

Let's have a look at the second version of the factory:

{% highlight scala %}
public class PizzaFactory {
       private final int season; // 1 => Winter, 2 => Spring, 3 => Summer, ...
       private PizzaFactory(int season) {
    	      this.season = season;
       }
       public static PizzaFactory of(int season) {
       	      return new PizzaFactory(season);
       }
       public static Pizza makePizza() {
	      return new Pizza(season);
       }
}
{% endhighlight %}

Now, we provide the season variable from outside of the factory, so we don't need to mock the method call `makePizza()` in our test cases which require a summer pizza:

{% highlight scala %}
@Test
public void testSummerPizza() {
       Pizza summerPizza = PizzaFactory.of(Season.SUMMER).makePizza();
       Result result = actualInstanceUnderTest.eat(summerPizza);
       assertThat(result.getStatus(), Stomach.FULL)
}
{% endhighlight %}

With a simple touch, you see how we got rid of mocking in this case.

## Conclusion

I do not mind that refactoring the design is a silver bullet and will always discard the need of mocking in every case. However, in most cases smart design decisions would help you avoiding using mocking frameworks. If you involve testing motivation in early phases of development, you can detect such workaround-like tendencies as fast as possible what in turn gives you a chance to reconsider the design before it is too late.
