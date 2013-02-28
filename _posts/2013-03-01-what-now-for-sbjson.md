---
layout: post
title: What now for SBJson?
published: false
---

In the middle of 2007 I was given roughly six months notice that I would be made redundant
from Fotango as the company was to be shut down. Around the same time CouchDB started to
emerge and caught my interest. Given I had some spare time on my hands, I set out to try
and write some Objective-C CouchDB bindings.

Fairly soon I was hindered by the lack of a suitable Objective-C JSON library. I decided
to write one. How much work could it really *be*? I temporarily shelved the CouchDB
bindings and started working on what would become SBJson. The first version was just a
category on `NSScanner`; however, for the first public release (v0.1) it had changed to
the category methods on `NSArray`, `NSDictionary`, and `NSString` that people know and
love today.

Version 2 added an OO interface, the single SBJSON class. Version 2.2 extracted separate
SBJsonParser & SBJsonWriter classes from that, and deprecated it. (It was a mess.) Each
step of the way the existing APIs were re-defined in terms of the new, lower-level APIs to
keep backwards compatibility. I did a booboo with the v2.3 release and removed the
aforementioned `SBJSON` class in a minor release. In retrospect I should simply have
called this version 3.

Starting in 2008 people were able to write their own apps for the iPhone. It turns out the
iOS SDK was lacking was JSON support, and many *many* people started using SBJson. Over
the years:

* Apple used it for their Stanford University iPhone course.
* Apple used it in iOS itself from iOS 3 onwards.
* Google Maps for iOS until iOS 6.
* The Flickr iOS app.
* The Facebook SDK.
* Instagram.

In June 2011 I released SBJson version 3. This release saw streaming support, an even
lower level API than the regular OO one. This time the OO API was re-defined in terms of
the streaming API, so yet again we kept compatibility. Actually I added two streaming
APIs, one low-level and one high-level. So now we have *four* levels of APIs.

------

*There is more than way to do it* is [...] but I have come to prefer the Pythonic way:
there should be one _defined best_ way to do it. This simplifies documentation, and
testing (if you don't support more than one way, at least.)

March 2013. Things, as they say, they are a-changing. iOS 5 was released nearly a year and
a half ago and added native JSON support in the iOS SDK. I would neither expect nor
recommend anyone to use SBJson if `NSJSONSerialisation` covers their need, so there really
is only two cases where I see SBJson providing value:

1. You need streaming support.
2. You're adding JSON support to an app that needs to support iOS version 4.x or below.

If you're adding JSON support to an iOS 4.x (or lower) app at this point, I think having
to call `[[SBJsonParser new] objectWithString:foo]` rather than `[foo JSONValue]` is
probably going to be the least of your problems. Thus, version 3.2 saw the category
methods deprecated, and will be removed in V4. This will allow me to keep focusing on
keeping SBJson relevant. (More and more, this will be the streaming support.)

The main reasons for cutting the category methods are:

1. Support. Failing to specify the correct flags to get categories working on iOS is the
biggest issue people currently have with the library. (Except perhaps imagined memory
leaks, from people compiling SBJson without ARC.)
2. Support, again. When the category methods return nil, there's no obvious way to get at
the error. In 3.x the methods NSLog the error, but it's not ideal. I don't want to throw
exceptions either.

This change is to allow me to focus on what makes this library stand out, which now really
is streaming support. It is important to note that the coding master, which you've just
pulled, is what will become 4.0. I do not change backward compatibility in minor releases.
(Intentionally.)

It is difficult to say how many use that second argument, of course, since I don't
instrument the library in any way. But I can say with certainty that nobody who have had a
problem and posted on stack overflow showed that they used it in any meaningful way. I
think people simply don't understand how to use these error pointers.

And, by the way, now that Objective-C has blocks I think it would be much nicer to provide
a block based interface. This also ties in with the idea of an event-based/streaming
interface.

Lessons:

- People don't bother reporting bugs to the maintainers, as a whole. They rather will
bitch on forums, or in comment threads on random blogs that happen to mention usage of the
software.
- People just can't/won't read documentation shipped with the software, but will spend
countless hours spreading lies/misunderstandings about the software they failed to use.
- throwing exceptions is the only way you're going to get your users to read error
messages. And many will ignore even those. Want your library to be a good citizen and
return nil, and have people check an error flag? Fine, but be prepared for support
requests asking along the lines of “WHY IS THIS RETURNING NULL?!?!?” :-)


----

2013: I still maintain SBJson, aka json-framework. I never really got around to play with
CouchDB, let alone finish those bindings...

