---
title: Delighting your users with SBJson 4
layout: post
---

I was asked to speak about SBJson at
[Cocoa Kucha 2](http://blog.cocoapods.org/Cocoa-Kucha-2/) on the 16th
of January 2014 and used the opportunity to try to explain why I think
SBJson is still relevant---even after Apple added native JSON support
to iOS 5 in 2011. This post summarises the main points of my talk.

* [Video of the talk](https://vimeo.com/86478323)
* [Slides](https://speakerdeck.com/stig/delighting-your-users-with-sbjson-4)

Have you ever written an app that downloads a list of records? I
believe this is a common theme in many apps. If it's a long list the
app may appear to hang, "go blank", or show a loading screen before
displaying anything to the user.

One popular work-around for downloading long lists on slow connections
is to use pagination (download part of the list at a time) to avoid
your users having to wait too long before they see anything. However
this chopping up of the data can introduce inconsistencies,
particularly in fast-moving data, because you can either have the same
item in two pages, or you may miss items.

I believe it may not always be necessary to put up with the above
tradeoffs. I assert that users usually care about time to first
record, not time to last. With SBJson you can get all records in one
big list (and therefore save yourself the connection overhead and
other headaches associated with doing multiple requests) but start
parsing the stream and feeding records to your users *before the
download of the full list has finished*.

SBJson supports streaming of two different types of input:

1. By downloading a stream of not one, but many stand-alone JSON
   documents. (Twitter provides streams of this type.) See
   [+multiRootParserWithBlock:errorHandler:][].
2. By *unwrapping a root array* and feed every top-level element
   inside the root to your application, one by one. See
   [+unwrapRootArrayParserWithBlock:errorHandler:][].

[+multiRootParserWithBlock:errorHandler:]: http://cocoadocs.org/docsets/SBJson/4.0.0/Classes/SBJson4Parser.html#//api/name/multiRootParserWithBlock:errorHandler:
[+unwrapRootArrayParserWithBlock:errorHandler:]: http://cocoadocs.org/docsets/SBJson/4.0.0/Classes/SBJson4Parser.html#//api/name/unwrapRootArrayParserWithBlock:errorHandler:

To see benefits for your users your app might require a bit of
re-engineering. You would typically push the parsing into the download
delegate, so either in [NSURLConnectionDataDelegate][]'s
connection:didReceiveData: or [NSURLSessionDataDelegate][]'s
URLSession:dataTask:didReceiveData: methods. Essentially you feed data
portions directly to the parser instead of using an accumulator like
this:

[NSURLConnectionDataDelegate]: https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLConnectionDataDelegate_protocol/Reference/Reference.html
[NSURLSessionDataDelegate]: https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSessionDataDelegate_protocol/Reference/Reference.html


{% highlight objc %}
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dt
    didReceiveData:(NSData *)data {

    switch ([parser parse: data]) {
       // handle various returns here…
   }
}
{% endhighlight %}

There are some caveats to parsing a stream of documents, particularly
when unwrapping root arrays. Normally a JSON parser would parse and
validate a complete document; however, that forces you to have seen
the entire document before parsing so when parsing streams we have to
relax that requirement.
