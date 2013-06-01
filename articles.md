---
title: Articles
layout: page
---

Some of these articles used to be available on&mdash;now discontinued&mdash;blogs I used
to have but I wanted to consolidate them in one place so now they are here. It used to be
that cool URLs never changed, but these did---and I'm OK with that.

This page lists all the available articles in reverse chronological order. You can also
browse the [articles by tag](/articles/tagged.html), or go straight to [my
favourite](/articles/tagged.html#Featured) articles.


<ul class="posts">
  {% for post in site.posts %}
    {% include post_li.html %}
  {% endfor %}
</ul>
