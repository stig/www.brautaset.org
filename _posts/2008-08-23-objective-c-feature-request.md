---
title: Objective-C Feature Request
layout: post
tags: [Objective-C]
---

<div class="right">
<img src="/images/2008/08/dictionary.jpg" alt="dictionary icon" width="266" height="262" />
</div>

Objective-C, particularly after it became 2.0, is my favourite language. It's partly
because of the language itself, but I guess mostly because of the libraries. The Cocoa
libraries are *awesome*.

For the most part. No software is perfect, and even in Cocoa there are things that could
be improved. One thing that continue to trip me up is one of `NSDictionary`'s initialiser
methods.

> Dear Apple,
>
> The `dictionaryWithObjectsAndKeys:` always end up confusing me, as the
> arguments always seem in the wrong order. It would make much more sense to
> have the method `dictionaryWithKeysAndObjects:` where you
> specified a list of key/value pairs, rather than value/key pairs.
>
> Yours Sincerely,
>
> Stig

Here's a random sample of the above from the [Adium](http://www.adiumx.com/)
source code. Honestly. I grabbed the first sample from it I could find. I did not hunt for
a particularly egregious example:

    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSValue valueWithPointer:SecKeychainLockAll],
            AIKEYCHAIN_ERROR_USERINFO_SECURITYFUNCTION,
        @"SecKeychainLockAll",
            AIKEYCHAIN_ERROR_USERINFO_SECURITYFUNCTIONNAME,
        AI_LOCALIZED_SECURITY_ERROR_DESCRIPTION(err),
            AIKEYCHAIN_ERROR_USERINFO_ERRORDESCRIPTION,
        nil];


Doesn't that make a lot more sense like this?

    NSDictionary *userInfo = [NSDictionary dictionaryWithKeysAndObjects:
        AIKEYCHAIN_ERROR_USERINFO_SECURITYFUNCTION,
            [NSValue valueWithPointer:SecKeychainLockAll],
        AIKEYCHAIN_ERROR_USERINFO_SECURITYFUNCTIONNAME,
            @"SecKeychainLockAll",
        AIKEYCHAIN_ERROR_USERINFO_ERRORDESCRIPTION,
            AI_LOCALIZED_SECURITY_ERROR_DESCRIPTION(err),
        nil];


This has confused me so many times now that I have filed a feature request with Apple
(<rdar://problem/6171269>) to have a new method with the arguments in the "right" order.
(Wondering if that url is broken? Read about [rdar
URLs](http://iphonedevelopment.blogspot.co.uk/2008/10/radar-urls-bug-reporting.html) only
work for Apple.) Here's to hoping that they honour it and put it in Snow Leopard...

