---
layout: post
title: Spray Routing Error Handling
tags: [Development, Scala]
---

I've recently taken a lot of inspiration from a blog post titled [Akka and Spray](http://blog.eigengo.com/blog_posts/akka-spray) over at the Eigengo blog. It covers a lot of ground and comes highly recommended if you are learning Scala, Akka & Spray. The only thing I didn't like was how it handled marshalling of errors, and I intend to show a better way here.

Imagine an endpoint to register a user. It should either return the user or a failure. If the user already exist, we want to return a 400 error, otherwise a 500 will do. Here's my exceptionHandler:

    implicit def exceptionHandler(implicit log: LoggingContext) =
        ExceptionHandler {
            case NotRegisteredException(_) => ctx =>
                val err = Error("Email Already Registered")
                log.warning("{} encountered while handling request: {}", err, ctx.request)
                ctx.complete(StatusCodes.BadRequest, err)
        }

I initially used `mapTo[Try[User]]` in my service:

    complete {
        (register ? req).mapTo[Try[User]]
    }

This works, however, I don't like that I have to wrap responses from the register actor in Success/Failure. And I _particularly_ don't like that I have to return an exception in the failure case:

    sender ! Success(User(...))

or

    sender ! Failure(NotRegisteredException(...))

You cannot simply ditch the `Success` and `Failure` wrappers and `mapTo[User]` because if you don't return a user you will just get a `ClassCastException` rather than anything useful you can handle in your exceptionHandler. However, I found I could use `collect` on the future to get the effect I want:

    complete {
        (register ? req).collect {
            case u : User => u
            case NotRegistered => throw NotRegisteredException(req.email)
        }
    }

Now, in my register actor, I don't have to wrap my values and am free to do this:

    sender ! User(...)

or

    sender ! NotRegistered

It feels right to me that the register handler should not have to know that its callers will be using the ask pattern, and that the service layer should chose the exceptions to throw in response to failure messages. I would argue it makes the `register` actor more reusable from non-REST contexts.
