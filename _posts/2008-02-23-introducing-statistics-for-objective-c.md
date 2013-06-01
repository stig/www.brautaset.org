---
title: Introducing Statistics for Objective-C
layout: post
tags: [Development, Objective-C]
---

[Statistics]: https://github.com/stig/Statistics

I have just released version 1.0 of [Statistics][]: an Objective-C Foundation framework
inspired by Perl's
[Statistics::Descriptive](http://search.cpan.org/dist/Statistics-Descriptive/). By that I
mean it has a similar interface, though is not a straight port.

Straight out of the box this framework provides count; min; max; range; mindex; maxdex;
biased and unbiased variance and standard deviation; mode; median; percentile; arithmetic,
harmonic, and geometric mean; and frequency distribution, optionally cumulative. In
addition you can return a new statistics object seeded with the same data **but with
outliers discarded**. Perfect if you're interested in the trimmed mean.

The code is released under the BSD license.
