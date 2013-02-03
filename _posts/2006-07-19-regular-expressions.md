---
layout: post
title: Regular Expressions
imported: 31/01/2013
tags: [Hacks]
---

*This post has been updated to reflect the contents of `/usr/share/dict/words` on OS X
Mountain Lion, and use egrep rather than Perl.*

---

A friend mentioned that the word "bookkeeping" was (apparently) the only English word that
had three consecutive groups of double letters in it. I decided to test this statement, so
I wrote a little regular expression to verify it. Here's the program, and the results of
running it:

> `% egrep '(.)\1(.)\2(.)\3' /usr/share/dict/words`
>
> bookkeeper<br/>
> bookkeeping<br/>
> subbookkeeper

So, it turned out he was right. (At the time this post was written, he was; subbokkeeper
has been added later, and I'll allow bookkeeping as a variant of bookkeeper.) Then I got
curious; what if the groups don't have to be consecutive? That's easy enough to check, so
let's do that:

> `% egrep '(.)\1.*(.)\2.*(.)\3' /usr/share/dict/words | wc -l`
>
> 170

Wow. I wonder if any of those have *four* groups of double letters in them? (Non consecutive?)

> `% egrep '(.)\1.*(.)\2.*(.)\3.*(.)\4' /usr/share/dict/words`
>
> killeekillee<br/>
> possessionlessness<br/>
> subbookkeeper<br/>
> successlessness


Those sure are some funny words...

