---
title: Articles
layout: default
---

Some of these articles used to be available on&mdash;now discontinued&mdash;blogs I used
to have but I wanted to consolidate them in one place so now they are here. It used to be
that cool URLs never changed, but these did; and I'm OK with that. Search engines are
pretty good nowadays.

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

*Some of the articles, especially the older ones, are rife with broken links. Sorry about
that. Maybe I'll get around to cleaning those up one day.*
