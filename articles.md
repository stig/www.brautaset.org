---
title: Articles
layout: page
---

All available articles; most recent first. (Alternatively, browse
[by tag](/articles/tagged.html).) Some of these used to be elsewhere,
but I wanted to collect them all together & now they are here. (It
used to be that cool URLs never changed, but these did---and I'm OK
with that.)

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
