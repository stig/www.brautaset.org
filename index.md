---
layout: page
title: Superloopy
---

This is my personal website, which is mostly a blog. Most will be tech
related, but anything goes really. Here are a few teasers from my most recent
articles:

<ul>
{% for post in site.posts limit: 5 %}

<li>
    <p class="post-title">
        <a href="{{ post.url }}">{{ post.title }}</a>
    </p>

    <p class="post-meta">
    Posted {{ post.date | date_to_string }}
    </p>

    <p>
        {{ post.excerpt }}
    </p>
</li>

{% endfor %}
</ul>
