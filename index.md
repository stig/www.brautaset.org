---
layout: page
title: Superloopy
---

This is my personal website, which is mostly a blog. Most will be tech
related, but anything goes really. Here are a few teasers from my most recent
articles:

<ul class="posts">
{% for post in site.posts limit: 3 %}

  {% include post-li.html %}

{% endfor %}
</ul>
