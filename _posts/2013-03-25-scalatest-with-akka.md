---
layout: post
title: Using ScalaTest with Akka
lead: Using ALL THE TRAITS
tags: [Development, Scala]
---

To test Actor code with ScalaTest you have to mix in a lot of traits; sometimes it can be
difficult to remember them all. Inspired by a course led by [Heiko
Seeberger](http://www.heikoseeberger.name) I made this abstract class (it cannot be a
trait because it takes constructor parameters) that you can drop into a project.

{% highlight scala %}
import akka.actor.ActorSystem
import akka.testkit.{ ImplicitSender, TestKit }
import org.scalatest.{ WordSpec, BeforeAndAfterAll }
import org.scalatest.matchers.MustMatchers

abstract class TestKitSpec(name: String)
    extends TestKit(ActorSystem(name))
    with WordSpec
    with MustMatchers
    with BeforeAndAfterAll
    with ImplicitSender {

  override def afterAll() {
    system.shutdown()
  }
}
{% endhighlight %}

You use it like this (extending the test part of my previous post on [injecting Akka's
TestProbe][inject] into actors):


{% highlight scala %}
object BarSpec {
  class Wrapper(target: ActorRef) extends Actor {
    def receive = {
      case x => target forward x
    }
  }
}

class BarSpec extends TestKitSpec("BarSpec") {
  import Bar._
  import BarSpec._

  trait TestCase {
    val probe = TestProbe()
    trait TestChildrenProvider extends ChildrenProvider {
      def newBar = new Wrapper(probe.ref)
    }
    val actor = context.actorOf(Props(new Bar with TestChildrenProvider))
  }

  "Bar" should {
    "involve child in doing something" in new TestCase {
      actor ! "SomeMessage"
      probe.expectMsg("MessageToChild")
      probe.reply("ReplyFromChild")
      expectMsg("ReplyFromParent")
    }
  }
}
{% endhighlight %}

I find this makes testing of Akka actors quite nice and clean.

[inject]: {% post_url 2013-03-24-injecting-akka-testprobe %}

