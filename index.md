---
layout: page
title: Summary of recent output
---

{% for post in site.posts limit: 10 %}
<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>

<div class="meta">Posted {{ post.date | date_to_string }}.
    {% if post.tags != empty %}
        {% for tag in post.tags %}{% unless forloop.first %}, {% endunless %}<a href="/articles/tagged.html#{{ tag }}">{{ tag }}</a>{% endfor %}.
    {% endif %}
</div>


<p>{{ post.excerpt }}</p>

<p><a href="{{ post.url }}">More...</a></p>
{% endfor %}
