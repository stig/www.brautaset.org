---
layout: post
title: Goodbye GPL, hello BSD?
tags: [Development]
---

Here's a question that's been on my mind lately:

> Should I switch away from using the GPLv2 for my software?
>
> So far I've been using the GPLv2, but now that it has been superseded by version 3 I'm a
> bit at a loss at what to use for new projects. Do I stick with using version 2? Do I
> read and try to understand version 3 enough that I'm comfortable using it? Or do I use
> something else entirely?
>
It's important to me that I'm able to fully comprehend the license I put on my own
software. The BSD license wins hands down in this category: it is short and written in
very simple language. For comparison here's the number of words in the BSD, GPLv2 and
GPLv3 licenses:

<table>
<tr><th>License</th><th>Number of words</th><th>Number of lines</th></tr>
<tr><td>BSD</td><td>223</td><td>26</td></tr>
<tr><td>GPL2</td><td>2968</td><td>340</td></tr>
<tr><td>GPL3</td><td>5644</td><td>674</td></tr>
</table>

A strong argument in favour of the BSD license there, but the length of each license is
not the full story. Lowering the barrier of entry is also important. You can use
BSD-licensed code in any closed-source applications&mdash;be it a commercial application
or binary-only freeware. (Maybe you're too embarrassed of the code to release it?)

More users means increased likelyhood of receiving feedback&mdash;in the form of code, bug
reports or otherwise&mdash;that benefit all users. Thus I'd rather have a larger pool of
"free" and "non-free" users than a smaller pool of "free" users of my software, even if
the "non-free" ones use it in a commercial application and don't directly contribute code
back.

At this point I've pretty much made up my mind. Unless someone hits me over the head and
points out a glaring flaw in my arguments upcoming releases of my software (at least the
libraries) will be released under the revised BSD license.
