---
layout: post
title: "Protocols and multimethods"
description: "Clojure provides multimethods and protocols which enables developers to implement runtime polymorphism."
date: 2018-09-05 16:41:50
author: Erhan Bagdemir
comments: true
keywords: "Clojure, Programming"
category: Software Engineering
image:  '/images/13.jpg'
tags:
- Clojure
- LISP
---


Similar in [Command Pattern](https://sourcemaking.com/design_patterns/command), that we are familiar from object-orient programming, Clojure provides multimethods and protocols which enable developers to implement such runtime polymorphism while forming abstractions in functional-fashion and implementations thereof. In this blog article, I will demonstrate an example as to explain how to leverage such polymorphism in Clojure. 

To conduct an interface-like abstraction, Clojure affords `defprotocol`, the function allows us define bodyless abstract functions with a name: 

```clojure
(defprotocol Command
  (perform [this metric city param]
    "Executes the command logic."))
```

Above, I am giving example of such an abstraction with the name "Command" defining a function without body, but including a parameter list and documentation. Just like interfaces in Java, the function `perform` has no body, at all. But, without a body the function cannot do that much. The next step is to give the `Command` a body as to make it come to life by using `deftype`:

```clojure
(deftype command-runner []         ➊
   Command
  (perform [this metric city day]  ➋
      (try 
          (run metric city day)    ➌
          (catch Exception e 
       		(handle-error e)))))
```

➊ `deftype` implements the abstract ➋ `perform` function with a body whereas this implementation introduces another abstraction level between the `perform` and the runner function, I named it `run `➌. I exactly want that the corresponding run function gets called depending on the metric passed to the `perform` function as parameter. For instance; the run implementation of "temp" fetches the temperature whereas "humidity" version returns the humidity on that day and in the city given. The question is how Clojure is able to decide which run implementation is to be called? The answer is `defmulti`and `defmethod`´:

```clojure
;; Multimethod definition showing that the run 
;; might have multiple informations. The identity
;; function is used as dispatcher function to 
;; determine which implementation of run is to be
;; called
(defmulti run identity)

;; The run method implementation for temp. 
(defmethod run "temp"
    [city day] 
    (get-temp city day))

;; Reads humidity.
(defmethod run "humidity" 
    [city day]
    (get-humidity city day))

;; Reads wind.
(defmethod run "windspeed"
    [city day] 
    (get-windspeed city day))

;; you are encouraged to add more functions.
```

With `defmulti` I introduced a multimethod which emphasises that the function might have multiple  implementations - and it does indeed for various metrics: temp, humidity and windspeed, and you are welcome to add more. The first parameter is the name of the multimethod and the second one is the dispatcher function. The dispatcher function is an important one such that it is used to determine which implementation of multimethod is to be executed, that are embodied by `defmethod`. So, which one? 

It is regulated by matching the return value of the dispatcher function, the dispatch value, while applying the command parameter to it and the string literal in `defmethods` given as the second parameter. In the example above, we call `(run metric city day)` and let's assume that the command is "temp", the identity function give back "temp" which matches the dispatch value defined in `defmethod`, "term", so the term version of the run function will be executed in runtime.

