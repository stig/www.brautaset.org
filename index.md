---
layout: page
title: Superloopy
---

Below are teasers from my most recent articles.

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
