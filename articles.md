---
title: Full Article List
layout: page
---

All articles, most recent first. You can also browse
[by tag](/articles/tagged.html). Some of these used to be elsewhere,
but now they are here. It used to be that cool URLs never changed, but
these did---and I'm OK with that. (I'll leave it as an exercise for
the reader to decide if they're cool or not.)

<ul class="posts">
  {% for post in site.posts %}

  <li>
    <a href="{{ post.url }}">{{ post.title }}</a>
    <div class="meta">Posted {{ post.date | date_to_string }}.
    {% if post.tags != empty %}In
        {% for tag in post.tags %}{% unless forloop.first %}, {% endunless %}<a href="/articles/tagged.html#{{ tag }}">{{ tag }}</a>{% endfor %}.
    {% endif %}
    </div>
  </li>

  {% endfor %}
</ul>
