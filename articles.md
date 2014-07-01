---
title: Articles
layout: page
---

This page lists all articles available on this this site in reverse chronological order.
Alternatively the [front page](/) now contains the ten most recent posts with an excerpt
of each. You can also browse the [articles by tag](/articles/tagged.html).

Some of these articles used to be available on---now discontinued---blogs I used
to have but I wanted to consolidate them in one place so now they are here. It used to be
that cool URLs never changed, but these did---and I'm OK with that.

<ul class="posts">
  {% for post in site.posts %}
    {% include post_li.html %}
  {% endfor %}
</ul>
