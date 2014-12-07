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

**Update 2014/01/07:** I've received several pieces of feedback on
this post. First a friend pointed out in private email:

> There's another way around this problem: something like oauth. Sure,
> it's a fucker to implement correctly, but there are other systems
> out there that offer similar capabilities (facebook login, your
> google ID, Twitter also support authentication) I don't see what
> benefit this approach offers over those.

Personally I find OAuth, particularly in mobile apps, a terrible user
experience. It's just about bearable in browser-based apps, but the
way it bounces you back and forth between native mobile apps makes it
seem like your phone is having an epileptic fit. My dad would probably
throw the device across the room in the belief it was possessed. (And
would call me to exorcise it.)

If you've used computers in anger for a while it's easy to get forget
all the horrible things we put up with in the name of security, but I
think OAuth in particular seriously alienates non-technical users. ("I
went to log in, and suddenly I was at a different site! *Crazy!*")
And from the perspective of the site maintainer, if OAuth really *is*
"a fucker to implement correctly" that alone is a fairly strong
argument against it in my opinion.

Facebook Login, Google ID and Twitter Auth might be simpler to
implement than OAuth. (Disclaimer: I don't know---I've never
implemented any of them.) And all have the benefit that they are well
known services, and so many people trust them---perhaps more than they
trust your site! However they all also suffer the same problem: they
require you to have a particular type of account. I agree that if your
site integrates heavily with Facebook or Twitter then it would be
natural to support Facebook login or Twitter Auth. However if your
site offer Google ID and Facebook login but someone visiting your site
only has a Twitter account, well; that person probably won't register.

Offering *all* the possible options for third-party login isn't
practical, and as a site maintainer you probably shouldn't try. (In
[Paradox of Choice][] Barry Schwartz argues that if you give people
too many options it increases their anxiety and the risk that they
can't make up their mind---thus walking away with unfinished
business.) Finally, as a site maintainer you have to trust not only
that those services will stick around in the long term (they probably
will!) but that they will continue to support this service. (I seem to
recall that Twitter discontinued one authentication mechanism and left
a lot of users scrambling for an alternative.)

[paradox of choice]: http://en.wikipedia.org/wiki/The_Paradox_of_Choice

An email address on the other hand (at least if it's one from a domain
you own) follows *you* and is not relying on any particular company's
willingness to continue operating a service. Email has other problems
though, as jcs---the "owner" of previously mentioned
[lobste.rs][]---pointed out in [this comment][jcs objections]:

[jcs objections]: https://lobste.rs/s/hp5btv/invalid_username_or_password_is_a_useless_security_measure/comments/vj2k6p#c_vj2k6p
[Greylisting]: http://en.wikipedia.org/wiki/Greylisting

- Anyone with access to an SMTP server in the path between your site
  and the user's mailbox would be able to initiate login as you,
  intercept the email, and use the link in it to log in as you. Thus
  they don't need to be able to actually *log in* to your email; just
  intercept it in transit. With big providers like Google, Yahoo,
  Hotmail, etc I assume there wouldn't be many hops between your site
  and theirs---and if these organisations wanted your data, well, you
  already host your email with them anyway.
- Less of a security issue, but more a useability issue, he has found
  that email is unreliable and might not arrive---at least in a timely
  fashion---for numerous reasons including lack of "push"
  (particularly on iOS devices), spam-fighting tricks such as
  [Greylisting][], or mail simply disappearing (presumably being
  treated as spam) after being accepted by the recipient's SMTP
  server.

... aaand this is where my enthusiasm for this idea is starting to
falter. I will mull this over a while longer before putting the above
passwordless login flow into use.

## Conclusion

In the course of a day I've learnt many reasons why the scheme I
proposed, although having some nice properties in theory, is unlikely
to be successful in practice. I've rediscovered that I can save a lot
of time by---instead of diving into implementation---presenting an
idea and asking people smarter than me what's wrong with it. I should
do this more.
