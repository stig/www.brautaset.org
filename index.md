---
layout: page
title: Superloopy
---

I'm a polyglot software developer, and love playing with different
languages. Over the years have toyed with C, Prolog, Perl,
Objective-C, Java, Scala & Clojure. Employers have paid me to write
HTML, PHP, Perl, C, JavaScript, Java, Objective-C, Scala and English.

This is my personal website. As part of it I maintain
[a blog](/articles.html), and these are excerpts from my two most
recent articles:

<dl>
{% for post in site.posts limit: 2 %}

<dt>
<span class="post-title"><a href="{{ post.url }}">{{ post.title }}</a></span>
<span class="post-meta">&mdash; {{ post.date | date_to_string }}</span>
</dt>

<dd>
{{ post.excerpt }}
</dd>

{% endfor %}
</dl>

Free & Open Source Software
---------------------------

I wrote [SBJson][], a popular JSON parser
& generator for Objective-C. You are welcome to use it&mdash;and any
other project available from my [Github profile][github]&mdash;for
free, as long as you adhere to their respective licenses.

In most cases the license requires that you have to attribute me in
your application. I understand that this attribution requirement can
sometimes be a problem. If you let me know about the problem, I may
agree to grant you an alternative license.

[sbjson]: http://sbjson.org
[github]: http://github.com/stig
