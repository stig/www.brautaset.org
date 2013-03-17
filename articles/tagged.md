---
title: Articles by Tag
layout: page
---

This page lists all the available tags, with links to the tagged articles. Some articles
are listed under more than on tag. Jump to the specific tag you're interested in by
clicking on these links:

<ul>
{% for tag in site.tags order:ascending %}
    <li><a href="#{{ tag.first }}">{{ tag.first }}</a></li>
{% endfor %}
</ul>

[Featured](#Featured) articles is simply my own favourites, while [Popular](#Popular) is
as measured by Google Analytics. (These lists are not updated in realtime.)

{% for tag in site.tags %}

<h2 id="{{ tag.first }}">{{ tag.first }}</h2>

<ul class="posts">
  {% for post in site.posts %}
    {% if post.tags contains tag.first %}
      {% include post_li.html %}
    {% endif %}
  {% endfor %}
</ul>

{% endfor %}

