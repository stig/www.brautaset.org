---
title: Superloopy
layout: page
---

This is my personal website, which is mostly a blog. Sometimes I blog because
I have something to say, sometimes it's just to practice writing. Most
articles are tech related, but anything goes really. Here is the full list of
articles, with abstracts for the most recent:

<ul class="posts">
{% for post in site.posts %}

<li>
    <p>
    <span class="post-title">
        <a href="{{ post.url }}">{{ post.title }}</a>
    </span>

    <span class="post-meta">
        &mdash; {{ post.date | date_to_string }}
        {% if post.tags != empty %}<div>Posted in: {% for tag in post.tags %}{% unless forloop.first %}, {% endunless %}<a href="/articles/tagged.html#{{ tag }}">{{ tag }}</a>{% endfor %}</div>
        {% endif %}
    </span>
    </p>

    {% if forloop.index < 5 and post.abstract != empty %}
    <p>
        {{ post.abstract | escape }}
    </p>
    {% endif %}
</li>

{% endfor %}
</ul>

