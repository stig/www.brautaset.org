---
layout: page
title: Summary of recent output
---

{% for post in site.posts limit: 10 %}
<h2><a href="{{ post.url }}#top">{{ post.title }}</a></h2>

<p>{{ post.excerpt }}</p>

<p><a href="{{ post.url }}#top">More...</a></p>
{% endfor %}
