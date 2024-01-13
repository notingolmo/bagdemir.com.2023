---
layout: post
title: "R in Practice: Pipes"
description: "The more I write code in R, the more I am impressed with the facilities that the language provides which is perfectly tailored to cleaning and tidying data, one of the most crucial steps in statistical analysis."
date: 2017-04-09 16:41:50
author: Erhan Bagdemir
comments: true
keywords: "R, Statistics, Data Science"
category: Misc
tags:
- Data Science
- Statistics
- R
---

The more I write code in R, the more I am impressed with the facilities that the language provides which is perfectly tailored to cleaning and tidying data, one of the most crucial steps in statistical analysis. As you may also admit it, failing at choosing the right tools in development context, might end up with a futile endeavour. R is in that sense absolute the right sieve for data miner.

The operations like selecting, filtering, etc. and combining them in nested function calls while cleaning your data, might become a very tedious programming style. Not only will the readability of your code suffer from that, but also your R programs will become more fragile quickly. Fortunately, there are some libraries out there which make such chaining data processes much easier for you.

Let's start with an example in which we are going to work on the following data set of cars:  

{% highlight R %}
                mpg cyl  disp  hp drat    wt  qsec vs am gear carb                
Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
{% endhighlight %}

which has some features like,
**mpg** for miles per gallon,
**cyl** for cylinder,
**hp**  for horsepower,
**gear** for gear.

Our first task is to select the cars which have 4-cyl:

{% highlight R %}
mtcars[mtcars$cyl == 4, ]
{% endhighlight %}

With the raw selector form and a conditional, we can select the cars out which have exactly 4-cylinders. However, this form of filtering requires a weird expression and redundant usage of the name mtcars what might tend to be noisy.

It will even become worse, if you have more conditional expressions e.g:

{% highlight R %}
mtcars[mtcars$cyl == 4 & mtcars$hp > 100, ]
{% endhighlight %}

which filters the cars out with 4-cylinder and at least 100 hp.

{% highlight R %}
              mpg cyl  disp  hp drat    wt qsec vs am gear carb
Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2
Volvo 142E   21.4   4 121.0 109 4.11 2.780 18.6  1  1    4    2
{% endhighlight %}

Let's try the same expression with the `dplyr`.
If you haven't installed it yet,

{% highlight R %}
install.packages("dplyr")
library(dplyr)
{% endhighlight %}

`dpylr` package does provide some utility functions like *select*, *mutate*, *filter*, etc. which give you more convenient way of juggling with your data. Have a look at the following one:

{% highlight R %}
> filter(mtcars, cyl == 4, hp > 100)
   mpg cyl  disp  hp drat    wt qsec vs am gear carb
1 30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2
2 21.4   4 121.0 109 4.11 2.780 18.6  1  1    4    2

{% endhighlight %}

much easier to read and more intuitive. Let's take it a step further and use a sort of projection on our data and return only those columns which we are interested in, cyl and hp.

{% highlight R %}
filter(select(mtcars, cyl, hp), cyl == 4, hp > 100)
{% endhighlight %}

We use `select` for that. However, nesting expressions might also be very cumbersome, if the operations you perform on data, get longer. We need some sort of pipe operator to forward the output of one function to an another one like the pipe operator `|` in UNIX systems. Fortunately, the `dplyr` has something similar: `%>%`:

{% highlight R %}
> filter(mtcars, cyl == 4, hp > 100) %>% select(cyl, hp)
  cyl  hp
1   4 113
2   4 109
{% endhighlight %}

You don't even need to pass the name of the data set in the second function which will be inferred from the context.

Erhan
