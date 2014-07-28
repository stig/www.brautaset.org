---
layout: page
title: Summary of recent output
---

Here's what I've been writing most recently:

{% for post in site.posts limit: 5 %}
<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>

<p>{{ post.excerpt }}</p>

<div class="meta">Posted {{ post.date | date_to_string }}.

{% if post.tags != empty %}Tagged 

  {% for tag in post.tags %}{% unless forloop.first %}, {% endunless %}<a href="/articles/tagged.html#{{ tag }}">{{ tag }}</a>{% endfor %}.

{% endif %}
</div>


{% endfor %}
