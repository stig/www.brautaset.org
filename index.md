---
layout: page
title: I'm Stig
---

I'm a polyglot software developer, making software for fun and profit. I've
released toys and free software projects in C, Prolog, Perl, Objective-C, Java
and Scala. Employers have paid me to write HTML, PHP, Perl, C, JavaScript, Java,
Objective-C, Scala and English.

This is my website. As part of it I maintain [a blog](/articles.html),
and these are my two most recent articles:

<ul>
{% for post in site.posts limit: 2 %}

<li>
<span class="title"><a href="{{ post.url }}">{{ post.title }}</a></span>
<span class="meta">&mdash; {{ post.date | date_to_string }}</span>

{{ post.excerpt }}

</li>

{% endfor %}
</ul>

<!-- testing 2,34 -->

Free & Open Source Software
---------------------------

I'm the author of <a href="http://sbjson.org">SBJson</a>, a popular
JSON parser & generator for Objective-C. You are welcome to use
it&mdash;and any other project available from my
[Github profile][github]&mdash;for free, as long as you adhere to
their respective licenses.

In most cases the license requires that you have to attribute me in
your application. I understand that this attribution requirement can
sometimes be a problem. If you let me know about the problem, I may
agree to grant you an alternative license.

[github]: http://github.com/stig
