---
title: Delighting users with SBJson 4
layout: post
---

I was asked to speak about SBJson at [Cocoa Kucha 2](http://blog.cocoapods.org/Cocoa-Kucha-2/) on the 16th of January 2014. I used the opportunity to try to explain why I think SBJson is still relevant, even after Apple added native JSON support to iOS in iOS 5 (2011). This post summarises the main points of my talk.

* [Video of the talk](https://vimeo.com/86478323)
* [Slides](https://speakerdeck.com/stig/delighting-your-users-with-sbjson-4)

Have you written an app that downloads a list of records? I believe this is a common theme in many apps. My assertion is that users usually care about time to first record, not time to last.

One work-around for downloading long lists on slow connections is to use pagination (download part of the list at a time) to avoid your users having to wait too long before they see anything. This chopping up of the data can introduce inconsistencies in fast-moving data, because you can either have the same item in two pages, or you may miss items. And connection overhead means it will be ultimately slower to assemble the full list this way.

I believe it may not always be necessary to do these tradeoffs. Instead, with SBJson 4 you can get all records in one big list, but start parsing the stream and feeding records to your users *before the download of the full list has finished*. SBJson supports two different ways to do this:

1. By downloading a stream of not one, but many stand-alone JSON documents. (Twitter provides stream of this type.) See [+multiRootParserWithBlock:errorHandler:](http://cocoadocs.org/docsets/SBJson/4.0.0/Classes/SBJson4Parser.html#//api/name/multiRootParserWithBlock:errorHandler:).
2. By *unwrapping a root array* and feed every top-level element inside the root to your application, one by one. See [+unwrapRootArrayParserWithBlock:errorHandler:](http://cocoadocs.org/docsets/SBJson/4.0.0/Classes/SBJson4Parser.html#//api/name/unwrapRootArrayParserWithBlock:errorHandler:).

There are some caveats to parsing a stream of documents, particularly when unwrapping  root arrays. Normally a JSON parser would parse and validate a complete document; however, that forces you to have seen the entire document before parsing so when parsing streams we have to relax that requirement.
