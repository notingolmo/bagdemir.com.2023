---
layout: post
title: "Scala Companion Objects"
description: "It’s a very common approach to create new objects using factory methods in object-oriented programming as it is in Java."
date: 2015-02-15 16:41:50
comments: true
keywords: "Programming"
category: Programming
tags:
- Programming
---


It’s a very common approach to create new objects using factory methods in object-oriented programming as it is in Java. It allows us to decrease coupling between software components while realizing one of the most popular OOP-rule “base on abstractions instead of implementations”. However, the way of how we implement static factory methods in Scala is a little different than in Java, since Scala has no static methods.

In fact, using Scala singleton “object”s, we can implement the factories just like in Java. A basic example for an Object:
{% highlight Scala %}
object Blog {
   def showLength() {
       println("Length of the Blog is null.");
   }
}
{% endhighlight %}

A companion object of a class is, however, an object which has the same name as that class and can access all fields and variables of it. Here’s an example of how the Blog object access’ the private method showLength() of the Blog instance:

{% highlight Scala %}
object Blog {
   def createArticle(text:String) : Blog {
       new Blog(text)
   }
   def showInfo(article:Blog) {
      println("The size of the article: " + article.showLength());
   }
}

class Blog(private val article:String) {
   private def showLength() {
       article.length
   }
}
{% endhighlight %}

In particular, we can use companion objects for “Information Hiding” in our design. For example, if we don’t want our clients to create new instances of our class directly, we can make the default constructor of the Blog class “private”, moreover, we can mark the class members like fields and methods with private keyword so that only the companion object can access them:

{% highlight Scala %}
class Blog private (private val article:String) {
   private def showLength() {
       article.length
   }
}
{% endhighlight %}

Now, the only way to create a new object of Blog class is using its companion object, although it’s constructor is marked private:

{% highlight Scala %}
object Blog {
   def apply(article: String) {
       new Blog(article)
   }
}
{% endhighlight %}
Implementing apply() method in the Blog object, we can now create instances of Blog classes without using the “new” keyword. The Scala compiler transforms the Blog(“…”) statement to the function application Blog.apply(“…”) implicitly, since the Blog is an object.

{% highlight Scala %}
object Main {
   def main(args: Array[Object]) {
       val blog: Blog = Blog("Here is the Hello World blog.")
   }
}
{% endhighlight %}
Indeed, there is still to do in our design, since our static factory method doesn’t base on abstraction, but implementation returning the concrete Blog type. However, we can improve our design by adding a new trait – an interface for our blog implementation – and renaming our Blog class as BlogImpl as follows:

{% highlight Scala %}
trait Blog {
    def showLength()
}

object Blog {

   def apply(article: String) : Blog = new BlogImpl(article)

   private class BlogImpl(private val article:String) extends Blog {
       def showLength() {
           article.length
       }
   }
}
{% endhighlight %}
Now, our clients know only about the interface (trait), but not implementation details what we wanted to hide.
