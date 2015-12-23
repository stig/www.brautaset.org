---
title: Not so philosophically different after all?
layout: post
tags: [Clojure, Programming]
---

I found Chris Done's
[A philosophical difference between Haskell and Lisp](http://chrisdone.com/posts/haskell-lisp-philosophy-difference)
via its
[Lobste.rs' thread](https://lobste.rs/s/mjxvyn/a_philosophical_difference_between_haskell_and_lisp)
and my response ended up blog-post length so I decided to reproduce it here.

Chris opens with:

> One difference in philosophy of Lisp (e.g. Common Lisp, Emacs Lisp) and
> Haskell is that the latter makes liberal use of many tiny functions that do
> one single task. This is known as composability, or the UNIX philosophy. In
> Lisp a procedure tends to accept many options which configure its behaviour.
> This is known as monolithism, or to make procedures like a kitchen-sink, or
> a Swiss-army knife.

Now, I don't know Common Lisp, and not much Emacs Lisp, but his first example
does not hold for Clojure. I don't recognise it at all. For example, a
straight-forward beginner's implementation of this function:

> take all elements from the list–except the first three–that satisfy
> predicate p, and take only the first five of those

Would probably look like this:

{% highlight clojure %}
    (defn f [p coll]
      (take 5 (filter p (drop 3 coll))))
{% endhighlight %}

However, this would probably be more idiomatic to rewrite it using the
[`->>`](http://clojure.github.io/clojure/clojure.core-api.html#clojure.core/->>)
macro. This has the benefit that the wording in the spec matches the code
better:

{% highlight clojure %}
    (defn f'[p coll]
      (->> coll
           (drop 3)
           (filter p)
           (take 5)))
{% endhighlight %}


I'm not sure what's going on with the second problem:

> get all elements greater than 5, then just the even ones of that set.

It looks to me like _neither_ his lisp nor his Haskell solution works, as they
both get only the even numbers _below_ 5. So, I'll show my solution to both
the stated problem and my implementation of his examples in Clojure. The
stated problem first:

{% highlight clojure %}
    (filter even? (iterate inc 5))
{% endhighlight %}

Rewritten with `->>`:

{% highlight clojure %}
    (->> (iterate inc 5)
         (filter even?))
{% endhighlight %}

The problem that his code examples solve I would do like this:

{% highlight clojure %}
    [2 4]
{% endhighlight %}

Ok, that was cheeky, so let's show it with code too:

{% highlight clojure %}
    (filter even? (range 5))
{% endhighlight %}

or, if `0` is not desired:

{% highlight clojure %}
    (filter even? (range 1 5))
{% endhighlight %}

Range has a `step` option too, but I'd hardly call it a kitchen sink function:

{% highlight clojure %}
    user> (doc range)
    -------------------------
    clojure.core/range
    ([] [end] [start end] [start end step])
      Returns a lazy seq of nums from start (inclusive) to end
      (exclusive), by step, where start defaults to 0, step to 1, and end to
      infinity. When step is equal to 0, returns an infinite sequence of
      start. When start is equal to end, returns empty list.
    ;; => nil
{% endhighlight %}

So we could solve this like this too:

{% highlight clojure %}
    (range 2 5 2)
{% endhighlight %}

Alternatively, if you really want to use 2 functions, we could also emulate
his Haskell solution:

{% highlight clojure %}
    (take-while even? (range 1 5))
{% endhighlight %}


As others in the Lobsters thread commented, Scheme also favours small
composable functions. Perhaps all this shows is the problem of trying to
divine a philosophical difference between a single language and _family of
languages_ twice its age [with over 25 dialects listed on Wikipedia][lisp].


[lisp]: https://en.wikipedia.org/wiki/Lisp_(programming_language)
