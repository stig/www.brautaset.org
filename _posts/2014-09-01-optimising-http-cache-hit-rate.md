---
title: Optimising HTTP Cache Hit Rate
layout: post
---

I wrote a post over on our company blog titled
[Maximising Cache Hit Rates For Rest APIs][original]. My team is
responsible for producing (and supporting) the product API currently
being adopted across the organisation. In it I detail a few techniques
we've used to maximise our cache hit rate.

The TL;DR version:

- Require query parameters to be sorted alphabetically
- Require multi-value query parameters to be sorted
- Reject unrecognised query parameters

These restrictions serve to guard against accidental or unnecessary
differences in the URLs for functionally identical queries. For the
full details, please read the [original post][original].


[original]: http://techblog.net-a-porter.com/2014/08/maximising-cache-hit-rates-for-rest-apis/
