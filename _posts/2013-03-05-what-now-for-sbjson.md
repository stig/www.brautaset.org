---
layout: post
title: What now for SBJson?
tags: [Objective-C, Featured]
---

In the middle of 2007 I was given roughly six months notice that I would be made redundant
from Fotango as the company was to be shut down. Around the same time CouchDB started to
emerge and caught my interest. Given I had some spare time on my hands, I set out to try
and write some Objective-C CouchDB bindings.

Fairly soon I was hindered by the lack of a suitable Objective-C JSON library. I decided
to write one. How much work could it really *be*? I temporarily shelved the CouchDB
bindings and started working on what would become SBJson. The first version was just a
category on NSScanner; however, for the first public release (v0.1) it had changed to the
category methods on NSArray, NSDictionary, and NSString that people know and love today.

Version 2 added an OO interface, the single SBJSON class. Version 2.2 extracted separate
SBJsonParser & SBJsonWriter classes from that, and deprecated it. (It was a mess.) Each
step of the way the existing APIs were re-defined in terms of the new, lower-level APIs to
keep backwards compatibility. I did a booboo with the v2.3 release and removed the
aforementioned SBJSON class in a minor release. In retrospect I should simply have called
this version 3.

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

March 2013. Things, as they say, they are a-changing. iOS 5 was released nearly a year and
a half ago and added native JSON support in the iOS SDK, in the form of the
NSJSONSerialisation class. I would neither expect nor recommend anyone to use SBJson if
NSJSONSerialisation covers their need, so there really is only two cases where I see
SBJson providing value:

1. You need streaming support.
2. You're adding JSON support to an app that needs to support iOS version 4.x or below.

But doesn't NSJSONSerialisation support streaming too? Well, yes; in a sense.
NSJSONSerialisation supports NSStream, but it still will only give you the document after
it is finished parsing it. This means if you download a document over a slow link you will
never get any of the results until the entire document has been downloaded. And it has to
hold the entire finished document in memory, which could be a waste if you're only
interested in parts of it.

SBJson's streaming API doesn't use NSStream, but you can feed it parts of a large
(potentially endless) document in bite-sized NSData chunks, and register a delegate that
will receive various parts of the document as soon as they are parsed. *You never **have**
to hold the entire structure in memory.* It also means that if you're downloading a long
array over a slow link, you can *start showing results before the entire array has
finished downloading*. I chose the NSData chunks interface rather than a NSStream one
because it plays better with NSURLConnection and other HTTP libraries. It was also simpler
to implement and test.

Regarding the latter point: if you're having to add JSON support to an iOS 4.x (or lower)
app at this point, I think having to call `[[SBJsonParser new] objectWithString:foo]`
rather than `[foo JSONValue]` is probably going to be the least of your problems. Thus
version 3.2 saw the category methods, and the methods returning NSErrors through a
pointer, deprecated, and these will be removed in V4. I'm hoping this will allow me to
focus on keeping SBJson relevant.

It might seem such a small amount of code, so why not just keep them in? The main reasons
for cutting the the category methods are:

1. Support. Failing to specify the correct flags to get categories working on iOS is the
biggest issue people currently have with the library. (Except perhaps imagined memory
leaks, from people compiling SBJson without ARC.)
2. Support, again. When the category methods return nil, there's no obvious way to get at
the error. In 3.x the methods NSLog the error, but it's not ideal. I don't want to throw
exceptions either.

Regarding the removal of the methods that return errors through a parameter: it is
difficult to say how many use those successfully, since I don't instrument the library in
any way. But I can say from empirical observation (mainly in questions on
[StackOverflow](http://stackoverflow.com)) that people don't use those methods in any
meaningful way. People generally prefer them to the equivalent ones without the error
parameter, *but they almost always pass NULL as the error argument*. I think people simply
don't understand how these error pointers work.

So this is where we are in March 2013: I still maintain SBJson, aka json-framework---I
never really got around to play with CouchDB, let alone finish those bindings. I was never
paid a single pence, directly, for this development; however, I did land a job in part due
to being its author. Also, I had a couple of free beers at a London iOS developers meeting
that ended up in a pub. So I consider myself well rewarded.

---

*Note that the removal of features described above have already landed on SBJson's master
branch. This is what will become version 4.0, eventually. If you want to stay on tried and
tested interface I suggest sticking to the 3.2 branch for now.*
