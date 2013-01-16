---
title: Introducing Statistics for Objective-C
layout: post
tags: [Objective-C]
---

I have just released version 1.0 of <a
href="http://code.brautaset.org/Statistics/">Statistics</a>: an Objective-C
Foundation framework inspired by Perl's <a
href="http://search.cpan.org/dist/Statistics-Descriptive/">Statistics::
Descriptive</a>. It has a similar interface, though is not a straight port.

Straight out of the box this framework provides count; min; max; range;
mindex; maxdex; biased and unbiased variance and standard deviation; mode;
median; percentile; arithmetic, harmonic, and geometric mean; and frequency
distribution, optionally cumulative.

In addition you can return a new statistics object seeded with the same data
<strong>but with outliers discarded</strong>. Perfect if you're interested
in the trimmed mean.

The code is released under the BSD license. If this sounds interesting you
really should head over to the <a
href="http://code.brautaset.org/Statistics/">Statistics</a> site and check
out the online API docs. Said API docs, by the way, even integrates into
Xcode 3 (curtsy of Doxygen). What more could you want?
