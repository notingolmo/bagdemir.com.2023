---
layout: post
title: "A Brief Story of flatMap"
description: "The function flatMap, in Scala, is basically a binding element (and also a functional combinator) in the language and key to understand some important concepts of functional programming, and in this blog article, I am going to introduce you some of these, which are heavily based on flatMap."
date: 2015-07-12 16:41:50
comments: true
keywords: "Programming"
category: Programming
tags:
- Scala
- Functional Programming
---

The function flatMap, in Scala, is basically a binding element (and also a functional combinator) in the language and key to understand some important concepts of functional programming, and in this blog article, I am going to introduce you some of these, which are heavily based on flatMap. I assume, that you have had some experience with Scala. If you don’t any, no reason to freak out. If you are familiar with the programming languages like Python, Ruby, etc. the language syntax of Scala is not that different. I am going to keep the examples as simple as possible, and you will find some inline explanations for the language structures, for those I am of the opinion that they may lead to some confusions.
What is flatMap?

flatMap is just a glue to “bind” two different types – but not necessarily different – together. It is a building stone of many functional concepts in Scala. Here is an example of the flatMap for M[T]:

{% highlight Scala %}
trait M[T] {
 def flatMap[U](f: T => M[U]): M[U]
}
{% endhighlight %}

If you are not familiar with Scala, f: T => M[U], is a functional type definition. It indicates, that f is a function, which takes a parameter of type “T” and return a type of “M[U]“. Say, the type M provides some data in type of T, and the flatMap takes a function to produce M[U] from that T.

In some standard library types, the flatMap is already implemented, e.g List :

{% highlight Scala %}
val list = List(1,2,3,4,5)
list.flatMap(e => List(e - 1, e, e + 1))

res0: List[Int] = List(0, 1, 2, 1, 2, 3, 2, 3, 4, 3, 4, 5, 4, 5, 6)
{% endhighlight %}

It’s not a rocket science by now, at all. The flatMap implementation of Scala’s List, takes these intermediate sequences created by the function, f: e => List(e – 1, e, e + 1), and flattens them all as a list of the parameterised type – in this case U and T refer to the same type, Int, where as the map function call leaves out the intermediate sequences, as they are:

{% highlight Scala %}
val list = List(1,2,3,4,5)
list.map(e => List(e - 1, e, e + 1))

res0: List[List[Int]] = List(List(0, 1, 2), List(1, 2, 3), List(2, 3, 4), List(3, 4, 5), List(4, 5, 6))

{% endhighlight %}
However, this example of flatMap is not that exciting and does not expose the real power of the flatMap function. So, let’s look at the following for comprehension example:

{% highlight Scala %}
for (i  1 to n; if i > j)
  yield (i, j)
{% endhighlight %}
The for expression above combines all numbers from 1 to m and 1 to n and applies the filter on the result pairs. It would produce, then, the Vector containing the following Int pairs, in which the first value is greater that the second one:

{% highlight Scala %}
(2,1), (3,1), (3,2), (4,1), (4,2)…
{% endhighlight %}

But, sequence comprehension doesn’t look like really functional style, but rather imperative. Couldn’t we rewrite the same expression just using functions ? In fact, the for-comprehension is just a syntactic sugar in Scala. If you want to desugar this expression, you can still use -Xprint:parser flag and pass an expression as parameter, e.g

{% highlight bash %}
$ scala -Xprint:parser -e "for (i <- 1 to n; if i % 2 == 0) yield i"
{% endhighlight %}

However, the output will be a little obfuscated, because of the anonymous classes that the Scala compiler generates. If you are interested in result, you can give it a try at your home. I am not going to paste the generated code here, rather, we will get our hands dirty.

It is not that complicated to write it on your own. All you need is just combine the functions, flatMap, map and filter:

{% highlight Scala %}
 (1 to m).flatMap(i =>
   (1 to n).filter(j => i > j)
     map(k => (i, k)))
{% endhighlight %}

It is really easy. The flatMap version does exactly the same job as for comprehension does, but in a functional fashion. It is more transparent to the people that want to feel and live the theory behind.

So far, we have seen flatMap examples with Lists, however, flatMap is not only used within Scala Collections. Let’s move on and have a look at the following example:

{% highlight Scala %}
abstract class Option[+T] {
  def flatMap[U](f: T => Option[U]) : Option[U] = this match {
      case Some(x) => f(x)
      case None => None
  }
}
{% endhighlight %}

It is not the usage of flatMap, but a reference implementation of it in Option type. The flatMap implementation utilises the pattern matching to find out the instance type. None and Some case classes are sub types of the Option type. If “this” instance is in form of “Some(x)” – it is called constructor matching, then apply the function on the extracted value, x, otherwise it would be None, which indicates, currently no value, and returns a None, respectively.

Here are some examples of Option’s flatMap.

{% highlight Scala %}
// "x => x + 1" could be reduced to "_ + 1" using placeholder syntax.
> Some(10) flatMap(x => x + 1)
res0: Option[Int] = Some(45)

> Some(10) flatMap(x => None)
res0: Option[Nothing] = None

> List(Some(1), None, Some(3), None).map(a => \
  a.flatMap(b => Some(b + 1)))
res0: List[Option[Int]] = List(Some(2), None, Some(4), None)

// if you want to get the list of Ints
> List(Some(1), None, Some(3), None).map(a => \
     a.flatMap(b => Some(b + 1)))
         flatten
{% endhighlight %}

The difference between map and flatMap is important. If we use flatMap instead of map in the example above:

{% highlight Scala %}
> List(Some(1), None, Some(3), None).flatMap(a => \
  a.flatMap(b => Some(b + 1)))
res0: List[Option[Int]] = List(2,4)
{% endhighlight %}

the items are flattened without any need of calling flatten.

## An FRP Game Example

In fact, we can use map, flatten and flatMap functions in our own designs. Let’s say, that we build a new FRP game, in which the warriors carry some weapons. You can even increase the power of these middle-earth weapons by plugging gems (Ruby, Amethyst, etc. you name it) into them. As we gain experience points in the game, we can upgrade the blacksmith, who can forge our weapons. The gems you can find at leader enemies, who you have to skirmish to death, before you gain these priceless gems.

The following interface could be the first candidate of our Weapon design:

{% highlight Scala %}
// Gem to plug into the weapons
trait Gem
case class Ruby(hitPointBoost: Int) extends Gem
case class Emerald(hitPointBoost: Int) extends Gem
case class Empty(hitPointBoost: Int) extends Gem

trait Weapon[T  Weapon[U]): Weapon[U]
  def map[U  U): Weapon[U]
  def flatten(): T
}

class Sword[T](val gem: Option[T]) extends Weapon[T] {

  def flatMap[U](T => Weapon[U]): Weapon[U] = gem match {
    case Some(x) => f(x)
    case None => new Sword[U](None)
  }

  def map[U  U): Weapon[U] = gem match {
    case Some(x) => new Sword[U](Some(f(x)))
    case None => new Sword[U](None)
  }

  def flatten(): T = gem match {
    case Some(x) => x
    case None => Empty(0)
  }
}
{% endhighlight %}

The flatMap implementation in the Sword class, is not different than in the Option. The example is intended to convince you, that the functional combinators are not only designed for Scala’s standard libraries, but also in your own designs.

Now, we need someone to forge our weapons. In this sense, let me introduce the blacksmith in our universe:

{% highlight Scala %}
class Blacksmith {

  // transmutes the old weapon into a new one with the new gem.
  private def transmute[T, U](w: Weapon[T], newGem: U): Weapon[U] = new Sword[U](Some(newGem))


  // however, we needed to call flatten so we can get the gem back.
  def forge[T  transmute[T, U](w, u).flatten())
  }

  // you could eliminate the flatten call by replacing map with flatMap
  def forge2[T  transmute[T, U](w, u))
  }
}
{% endhighlight %}

The transmute function is kept very simple just to complete the whole story. Please do not pay attention to its implementation, but its signature.

## Three Rules of Monad

As the second version of the forge function does, you can use flatMap to reduce map and flatten method calls into a flatMap. So far, we have seen a couple of examples on flatMap, flatten and map functions. Have you ever noticed, that these both functions, map and flatMap, seem very similar to each other? You can, in fact, write the map function in terms of flatMap, however, what you need, is just an another function, a unit function, which ties map and flatMap together:

{% highlight Scala %}
class M[T] {
 def flatMap[U](f: T => M[U]): M[U]
 // let's extend our type M with the unit function
 def unit[T](T => M[T]): M[T]
}
{% endhighlight %}

You can now greet your (first? *) monadic type within this article. In Scala, a monad is a parameterized type, which provides a unit and a flatMap function and satisfies some rules. At first glance, monad sounds scary and fancy, when you hear its name for the first time. You will probably find dozens of articles on monads and category theory. However, from the programmer’s perspective, a monad is just a design pattern like any other design patterns, which you are probably familiar with e.g in object-oriented programming, but with functional fashion:

Let’s write a very simple unit function to complete the chain:

{% highlight Scala %}
def unit[T](opt:Option[T]) = Sword[T](opt)
{% endhighlight %}

Now, as I pointed out, we can even write the map function using flatMap and unit.

{% highlight Scala %}
 def map[U](f: T => U): M[U] = flatMap(x => unit(f(x)))
{% endhighlight %}

The unit function takes an Option type of the Gem as a parameter and gives the monad back. I’d already told you, that the monad must have complied with some rules to qualify as a monad. In our case, the sword is a monad, since it provides a constructor type (in this case the Sword[T)], a unit function and a flatMap. However, it must still satisfy some algebraic rules like associativity, left unit and right unit.

There are three rules, that a monadic type must still hold:
1. Left unit rule

{% highlight Scala %}
unit(x) flatMap f == f(x)
{% endhighlight %}

2. Right unit rule

{% highlight Scala %}
m flatMap (x => unit(x)) == m
{% endhighlight %}

3. Associativity rule.

{% highlight Scala %}
(m flatMap f) flatMap g == m flatMap(x => f(x) flatMap g)
{% endhighlight %}

## Is our Sword a monad?

Let’s, first, have a look at the “left unit” rule and apply it to our Sword example. To simplify the substitution model, I have just omitted the parameterized types and the HP boosts in the constructors of the gem case classes:

{% highlight Scala %}
 unit(Some(Ruby)) flatMap f        //== f(Some(Ruby))
 Sword(Some(Ruby)) flatMap f       //== f(Some(Ruby))

 {
  case Some(x) => f(x)
  case None => new Sword(None)
 }                                 //== f(Some(Ruby))

 f(Some(Ruby))                     //== f(Some(Ruby))
{% endhighlight %}

As you see, the first rule holds. Let’s move on to the second one, “right unit” rule, for “m = Sword(Some(Ruby))”:

{% highlight Scala %}
 m flatMap (opt => unit(opt))      //== m
 m flatMap (opt => Sword(opt))     //== m

 {
  case Some(x) => f(Some(Ruby))
  case None => new Sword(None)
 }                                 //== m

 f(Some(Ruby))                     //== m
 Sword(Some(Ruby))                 //== which is in turn an m
{% endhighlight %}

We are now one step away from the proof. It is the associativity rule, for “m = Sword(Some(Ruby))”, we have to show:

{% highlight Scala %}
(m flatMap f) flatMap g  == m flatMap( x => f(x) flatMap g)
{% endhighlight %}

Now, let’s apply step-by-step the substitution model to our example:

{% highlight Scala %}
 // 1.
opt match {
    case Some(x) => f(x)
    case None => new Sword(None)
} match {
    case Some(y) => f(y)
    case None => new Sword(None)
}    

// 2.
opt match {
  case Some(x) =>
    f(x) match {
      case Some(y) => f(y)
      case None => new Sword(None)
    }  
  case None =>
    new Sword(None) match {
      case Some(y) => f(y)
      case None => new Sword(None)
    }  
}
// 3.
opt match {
  case Some(x) =>
    f(x) match {
      case Some(y) => f(y)
      case None => new Sword(None)
    }
  case None => new Sword(None)
}
{% endhighlight %}

If you have noticed, that the first case expression’s body is the implementation of the flatMap function. If we continue with substitution, we get the expression on the right hand side of the equation of the equation, what we wanted to prove:

{% highlight Scala %}
// 4.
opt match {
  case Some(x) => f(x) flatMap g
  case None    => new Sword(None)
}
// 5.
m flatMap (x => f flatMap g ) // == (m flatMap f) flatMap g
{% endhighlight %}

So we can say now, that the Sword is obviously a monad.

* The weapon type is actually not the first monad example, that I have mentioned in this article. The Option and the List are monads as well.

## Summary

The flatMap is the building stone of monadic types in Scala. Understanding functional combinators like map, flatMap and flatten opens the gates of the kingdom of functional programming. In this article, I have introduced you the flatMap function. More will be available soon.

Further reading: I am currently working on an another article, in which I will give you some examples, revealing the real power of monads in Scala and show you, how you can manage the complexity using monads in your software designs. Until the new article is published, if you want to know more about Monads, you can watch this beautiful video by Dan Rosen:



Stay tuned!

Erhan
