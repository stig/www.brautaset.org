---
layout: post
title: A lesson in testing
imported: 30/01/2013
tags: [Development]
---

A while back I wrote a basic Neural Net class in Objective-C, and tested it pretty well.
Or, so I thought. The net was a bit slow at calculating output, so I decided to rewrite
it. I had originally used Objective-C arrays for simplicity, but they were hurting
performance so I decided to swap its implementation for C arrays instead. However, my test
suite had poked inside the internals of the class, so at every step I was now having to
rewrite the tests as I was rewriting the internals of the class I was testing. I did this
to keep the interface small, but it was really biting me in the ass now.

I ended up reverting all the changes I had made and completely rewriting the test suite to
only use the provided interface of the class, adding to the interface as needed. After
cleaning up the test suite (this had the unforseen side-effect of making the interface a
lot nicer to work with) I rewrote the internals as I had planned and managed to get a
five-fold speed increase, without changing any of the tests at all.

**Lesson learned:** don't be afraid to enrich your interface if it makes your code easier
to test.
