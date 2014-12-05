---
title: Passwordless registration and login
layout: post
tags: [ Design ]
---

I have been thinking about passwordless login lately, and wondering
why it's not used more. A couple of days ago I was reading a thread on
[lobste.rs][] and came across this [blog post][] by Nick Moore on the
subject. It inspired me to post my own thoughts.

[lobste.rs]: https://lobste.rs/s/hp5btv/invalid_username_or_password_is_a_useless_security_measure
[blog post]: http://nick.zoic.org/etc/the-selfish-secret-logins-without-passwords/

I hate having to remember different passwords for different sites.
Password managers help, but I often end up using a site’s “password
reset” feature as a one-time password service. That is: every time I
come to login and use the site I reset my password. I suspect I’m not
the only one. So how about we make that the default login flow?

The basic idea is that rather than supplying an email and a password
when you register or sign in to a site you just supply the email
address. The site sends you an email with an embedded one-time
password, and visiting that link within *N* minutes will show a big
fat "Confirm Login" or "Confirm Registration" button as appropriate.
If the link has been used before, or you wait longer than *N* minutes
before visiting, the page simply says the link is no longer valid and
prompt you to go through the process again.

The main benefit to *users* is that they don't have to remember (or
manage) yet another password for yet another site. There’s even more
benefits for the site maintainers though. Since there’s no
user-supplied passwords, there's:

1. No need to maintain a separate password reset functionality: users
   always go through the regular login procedure.
2. No need to maintain client-side password strength checks.
3. Less chance an attacker can simply guess or brute-force a password.
   (Let's assume we're not up against clearvoyant attackers that can
   reliably guess UUID-style passwords on the first attempt.)
4. The registration step has baked-in email verification, so there's
   no need to maintain a separate path for that either.

There's only really one snag I can think of compared to the
traditional login + password approach: *We rely on users having
convenient access to their email on the system they’re logging in
from*. So this scheme would not be ideal if you're not logging in from
your own computer. However, many of us carry around our computers
these days; and most mail providers offer web mail, so I don't think
this is a major roadblock.

Taken to the extreme this snag could land users in real trouble if
they registered with an email address they no longer have access to.
With the traditonal approach you could luck out and remember the
password, and thus be able to login. (Although whether you’ d be able
to update your email address is another matter: well-behaved sites
usually send an email to your old address for confirmation that you
actually want to update.) Recommending people register a secondary
email address, or a phone number that can receive SMS, could save some
support emails in this situation.

I can imagine some people objecting to requiring an email roundtrip
for to complete user registration. However, many sites already require
email verification after registration and I don't see this being
substantially different. If anything, it's simpler to maintain because
there's just one path. And there's nothing stopping you from letting
them start using your site straight away and just rely on session
state until they've finished registering.

I've been mulling over the idea of passwordless registration and login
for some time, and for the above reasons I am fairly confident it will
work. I don't think there are any glaring security issues compared to
the traditional approach; I am indeed confident it is *more* secure.
