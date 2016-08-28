---
title: Superloopy
layout: page
---

This is my personal website, which is mostly a blog. Sometimes I blog because
I have something to say, sometimes it's just to practice writing. Most
articles are tech related, but anything goes really. Here are a few teasers
from my most recent articles:

<ul class="posts">
{% for post in site.posts limit: 3 %}

  {% include post-li.html %}

{% endfor %}
</ul>

and here is the remaining list:

<ul class="posts">
{% for post in site.posts offset: 3 %}

<li>

    <span class="post-title">
        <a href="{{ post.url }}">{{ post.title }}</a>
    </span>

    <span class="post-meta">
        &mdash; {{ post.date | date_to_string }}
        {% if post.tags != empty %}<div>Tags: {% for tag in post.tags %}{% unless forloop.first %}, {% endunless %}<a href="/articles/tagged.html#{{ tag }}">{{ tag }}</a>{% endfor %}</div>
        {% endif %}
    </span>

</li>

{% endfor %}
</ul>
