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

This example shows how to wire together a REST API using Spray Routing (1.2)
that uses a separate service and (toy) actor-based model. It also shows off a
few things I consider good practice:

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

Let's start with the Model. This particular one is just a toy, because the
purpose of this example is to show how you plug an actor-based model into
spray routing. However, there's one thing I want to point out: the Model trait
has a method `get(id: Int)` returning `Option[Item]`. However, we don't want
to send `Some[Item]` messages from our `ActorModel`. (Because of type
erasure.) Luckily, an actor is not limited to responding with messages
extending a particular supertype so in the ModelActor we transform the
response into `Item` or `ItemNotFound` as appropriate.


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




