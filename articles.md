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
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
        <div class="meta">Posted: {{ post.date | date_to_string }}</div>
      </li>
    {% endif %}
  {% endfor %}
</ul>

## Articles by tag

(Some posts may be listed more than once under different tags.)

{% for tag in site.tags %}

<h3>{{ tag.first }}</h3>

<ul class="posts">
  {% for post in site.posts %}
    {% if post.tags contains tag.first %}
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
        <div class="meta">Posted: {{ post.date | date_to_string }}</div>
      </li>
    {% endif %}
  {% endfor %}
</ul>

{% endfor %}

## All Articles

Full list of articles available on this site. (Includes featured and tagged articles.)

<ul class="posts">
  {% for post in site.posts %}
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
        <div class="meta">Posted: {{ post.date | date_to_string }}</div>
      </li>
  {% endfor %}
</ul>
