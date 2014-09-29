---
title: Full Article List
layout: page
---

All articles, most recent first. You can also browse
[by tag](/articles/tagged.html). Some of these used to be elsewhere,
but now they are here. It used to be that cool URLs never changed, but
these did---and I'm OK with that.

<ul class="posts">
{% for post in site.posts %}
  <li>
    <span class="title"><a href="{{ post.url }}">{{ post.title }}</a></span>
    <span class="meta">&mdash; {{ post.date | date_to_string }}</span>
  </li>
{% endfor %}
</ul>
