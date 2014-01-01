---
layout: post
title: Spray Example
tags: [Development, Scala]
---

I love using [Spray](http://spray.io) for REST APIs, but a lot of the examples
I've seen using Spray Routing are just showing off its syntax. I've been
missing examples of how you can use it to wire together a real application.
Therefore I put together a [spray
example](https://github.com/stig/spray-example/) that goes a bit beyond the
routing layer to document my current understanding of best practices in that
regard. It is the topic of this article.

The main goal of this example (and this article) is to show how to wire
together a REST API using Spray Routing (v1.2) that uses a model-actor from
the spray routing layer. It also shows off a few things I consider good
practice:

* Custom `Cache-Control` header generation. Achieve optimal caching by
tailoring a resource's `max-age` to avoid over- or under-caching individual
resources.

* Separate on-the-wire protocol. I've see codebases where the domain objects
contain more annotations than code---often for both JSON and ORM mappings. I
think this is bad practice and prefer to use different objects.

* The [onSuccess](http://spray.io/documentation/1.2.0/spray-routing/future-
directives/onSuccess/) directive, which allows us to improve on my [previous][]
post on handling expected errors (e.g. 404) in the spray routing DSL.

* Use [sbt-revolver](https://github.com/spray/sbt-revolver). This is great
plugin by the Spray guys to simplify and speed up the dev/build/test cycle.

[previous]: {% post_url 2013-08-05-spray-routing-error-handling %}

* Stubbing out child actors for testing, using a variant of the *Cake
Pattern*. See the `TopLevelConfig` trait and its corresponding
`ProductionTopLevelConfig` implementation for more details.

Let's start with the [ModelActor][]. It is really just a toy, because the
purpose of this example is to show how you plug an actor-based model into
spray routing. There's just one thing I want to point out: the [Model][] has a
method `get(id: Int): Option[Item]`, but it is considered bad practice to send
`Some[Item]` and `None` messages between actors. Actors have much more freedom
when it comes to the types of messages it responds with so we transform the
response from the model into `Item` or `ItemNotFound` as appropriate.

[modelactor]: https://github.com/stig/spray-example/blob/master/src/main/scala/example/ModelActor.scala
[model]: https://github.com/stig/spray-example/blob/master/src/main/scala/example/Model.scala

Next, let's look at the [Service][] in more detail.

[service]: https://github.com/stig/spray-example/blob/master/src/main/scala/example/Service.scala

To avoid leaking exact
stock levels via the Cache-Control header's max-age we use a formula to
obfuscate the levels a bit.

The `onSuccess` directive allows us to handle two different success cases (or one success and one expected error, depending on how you look at it) in stride:

{% highlight scala %}
onSuccess(model ? id) {
    case item: Item =>
        complete(OK, scaledCacheHeader(item.stock + 1), toPublicItem(item))

    // Cache 404 for 60 seconds
    case ItemNotFound =>
        complete(StatusCodes.NotFound, cacheHeader(60), "Not Found")
}
{% endhighlight %}


The counter-argument to a separate on-the-wire protocol I've usually heard is
that it's "unecessary" work; but if you're dealing with immutable objects
you're probably just copying the pointers to the members, so you're not
copying that much data around. On the other hand it becomes a lot simpler to
avoid accidental leakage of your model fields if you never pass model the
model objects across the wire in the first place.


Running the example service
---------------------------

To start the example service, launch a terminal and cd into the directory and
run sbt. Once sbt starts the prompt will change to a `>`. You can now start
the example service in the background using the `re-start` command, provided
by the `sbt-revolver` plugin. If you change the code, just type `re-start`
again to re-launch.

    $ sbt
    > re-start

In a different terminal (or a browser), you can now call the service:

    $ curl localhost:8080/items
    $ curl 'localhost:8080/items?q=Qu'
    $ curl localhost:8080/items/2
    $ curl localhost:8080/items/23




