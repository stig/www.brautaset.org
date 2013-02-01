---
title: Articles
layout: default
---

Some of these articles used to be available on&mdash;now discontinued&mdash;blogs I used
to have but I wanted to consolidate them in one place so now they are here. It used to be
that cool URLs never changed, but these did; and I'm OK with that. Search engines are
pretty good nowadays.

## Featured Articles

A few of my personal favourites.

<ul class="posts">
  {% for post in site.posts %}
    {% if post.featured %}
      <li><span>{{ post.date | date_to_string }} </span>&raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endif %}
  {% endfor %}
</ul>

## All Articles

Full list of articles available on this site.

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }} </span>&raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
