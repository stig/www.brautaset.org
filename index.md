---
layout: page
title: Superloopy
---

Below are teasers from my most recent articles.

<dl>
{% for post in site.posts limit: 5 %}

<dt>
<span class="post-title"><a href="{{ post.url }}">{{ post.title }}</a></span>
<span class="post-meta">&mdash; {{ post.date | date_to_string }}</span>
</dt>

<dd>
{{ post.excerpt }}
</dd>

{% endfor %}
</dl>

