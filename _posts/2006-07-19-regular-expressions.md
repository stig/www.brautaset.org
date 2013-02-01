---
layout: post
title: Regular Expressions
imported: 31/01/2013
tags: [Perl, Regular Expressions]

---

Yesterday a friend mentioned that the word "bookkeeping" was (apparently) the only English
word that had three consecutive groups of double letters in it. I decided to test this
statement, so I wrote a little Perl oneliner. Here's the program, and the results of
running it:

> `% perl -n -e 'print $_ if /(.)(?:\1)(.)(?:\2)(.)(?:\3)/' /usr/share/dict/words`
>
> bookkeep <br />
> bookkeeper <br />
> bookkeeper's <br />
> bookkeepers <br />
> bookkeeping <br />
> bookkeeping's

So, it turned out he was (mostly) right. Then I got curious; what if the groups don't have
to be consecutive? That's easy enough to check, so let's do that:

> `% perl -n -e 'print $_ if /(.)(?:\1).<em>(.)(?:\2).</em>(.)(?:\3)/' /usr/share/dict/words | wc -l` <br />
> 118

Wow. I wonder if any of those have *four* groups of double letters in them?

> `% perl -n -e 'print $_ if /(.)(?:\1).<em>(.)(?:\2).</em>(.)(?:\3).*(.)(?:\4)/' /usr/share/dict/words | wc -l` <br />
> 0

Sadly, that's a no.
