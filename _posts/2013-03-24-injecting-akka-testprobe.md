---
layout: post
title: Injecting Akka's TestProbe in place of child actors
tags: [Development, Scala]
---

You have an actor that uses one or more child actors. You want to inject a TestProbe in
place of the child(ren) to test the behaviour of the parent in isolation. If your actor
takes another actor as a constructor parameter, this is simple. But what if it does not?

{% highlight scala %}
val foo = TestProbe()
val act = system.actorOf(Props(new Bar(foo.ref)))
{% endhighlight %}

Or, you can simply send your actor a message containing the probe as [this example from
the Akka documentation][multi-probe] shows. However, if your actor creates children itself
it can get more difficult. Here's an example setup from my (admittedly rather limited)
experience with Akka so far:

{% highlight scala %}
trait ChildrenProvider {
  def newFoo: Actor
}

trait ProductionChildrenProvider extends ChildrenProvider {
  def newFoo = new Foo
}

object Bar {
    def apply() = new Bar with ProductionChildrenProvider
}

class Bar extends Actor {
    this: ChildrenProvider =>
    val router = context.actorOf(Props(newFoo).withRouter(FromConfig()))
    def receive = {
        // ...
    }
}
{% endhighlight %}

This lets me inject a stubbed-out Foo instance in a test, but if you lump too much
behaviour in a single stub it can get very complex.  Much as in non-actor code I would use
Mock objects rather than stubs if I can, I would prefer to use TestProbes where possible.

For a while I struggled to see how I could inject a test probe into this second Bar. How
would I implement the `newFoo` method in my TestChildrenProvider? I could not just return
the `ref` on the TestProbe this time, as that returns an ActorRef, not an Actor. Turns out
the solution is to add yet another abstraction. (I should have known.)

Inspired by the [Forwarding Messages Received by Probes][fwd] section of the Akka TestKit
docs, I realised that I could use a similar technique, and create a wrapper around
TestProbe's `ref` as a constructor parameter:

{% highlight scala %}
class Wrapper(target: ActorRef) extends Actor {
  def receive = {
    case x => target forward x
  }
}

trait TestCase {
  val probe = TestProbe()
  trait TestChildrenProvider extends ChildrenProvider {
    def newFoo = new Wrapper(probe.ref)
  }
  val actor = context.actorOf(Props(new Bar with TestChildrenProvider))
}
{% endhighlight %}

This TestCase trait can then be wrapped around your code under test like so:

{% highlight scala %}
"Bar" should {
  "involve child in doing something" in new TestCase {
    actor ! "SomeMessage"
    probe.expectMsg("MessageToChild")
    probe.reply("ReplyFromChild")
    expectMsg("ReplyFromParent")
  }
}
{% endhighlight %}

This makes it much easier to reason about each test in isolation, and I'm less likely to
break other tests when adding data or behaviour to the stub to facilitate other tests. It
also makes it easier to add another test by copying and slightly tweaking an existing one.
(You should normally strive to DRY in code, but I believe some duplication is OK in tests.)


[multi-probe]: http://doc.akka.io/docs/akka/2.1.0/scala/testing.html#Using_Multiple_Probe_Actors
[fwd]: http://doc.akka.io/docs/akka/2.1.0/scala/testing.html#Forwarding_Messages_Received_by_Probes
