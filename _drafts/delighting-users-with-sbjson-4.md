---
title: Delighting users with SBJson 4
layout: post
---

How many here have written an app that downloads a list of records? Raise your hands please! Do you cut page size to reduce latency, at cost of connection overhead more times?

Slide 3: Red arrows is “download one record”, blue is “parse one record”. With the traditional approach, your app won’t get hold of any of the result until all has been downloaded & parsed.

Slide 4: Notice there’s no difference in when we get the last record; only in how early we get the first one. I’ve called it “chunked delivery” because it resonates with HTTP Chunks. Twitter, for example, lets your subscribe to a HTTP chunked stream of JSON documents.

Slide 5: Because downloads are multi-core we actually continue downloading without waiting for the parser to do its thing. Thus, at the end of the complete download you only have to wait for the parser to parse the last record.

Slide 10-11: Note that the input contains multiple top-level JSON documents concatenated together. (Assume the `data` function just creates an NSData instance containing UTF8 encoded data of the characters we pass it.) We can call the parse: method multiple times Twitter uses this style of streaming. Essentially each HTTP Chunk contains a complete JSON document.

Slide 14-15: In contrast to the previous example this input contains a single top-level document. The outer array is gray here.

Slide 16: In version 3 I supported unwrapping of objects as well, but it leaked keys. I also supported arbitrary-depth documents, but I removed it in the interest of clarity.

Slide 17: Normally a JSON parser would parse and validate a complete document, and would refuse to parse the above. However, that forces you to have seen the entire document before parsing so when parsing streams we have to relax that requirement.
The multi-root parser would still balk at the above, but the root unwrapping parser will call your value block twice, then call your error handler saying the next bit cannot be parsed.

Slide 18: The value block will be called once for each “chunk” of JSON we encounter. This will either be a top-level document (multi-root) or a first-level sub-document (unwrapping root array).

Slide 19: The -parse: method returns a status, which can be handy. An unwrap-root array parser will return …Complete when its root array is closed, for example. Or any parser will return …Stopped if you set the \*stop argument in the value block to YES.
