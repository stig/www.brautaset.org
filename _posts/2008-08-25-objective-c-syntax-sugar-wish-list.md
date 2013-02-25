---
title: Objective-C syntax sugar wish list
layout: post
tags: [Objective-C]
---

As I mentioned in my previous post Objective-C is my (current) favourite
programming language. But there things that could be improved. Creating
immutable collections is a bit verbose, for example. (Although&mdash;I
suspect&mdash;no more so than in for example Java.) It goes like this:

    NSArray *array = [NSArray arrayWithObjects:
        @"one", @"two", @"three", nil];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInteger:1], @"one",
        [NSNumber numberWithInteger:2], @"two",
        [NSNumber numberWithBool:YES], @"true",
        nil];

However, you don't have to use this syntax for strings. Static strings are
created with a special syntax, like so:

    NSString *string = @"This is a string";

It would be great if this could be extended to arrays and dictionaries. The
syntax would be something like this:

    NSArray *array = @[ @"one", @"two", @"three" ];

    NSDictionary *dict = @{
        @"one", [NSNumber numberWithInteger:1],
        @"two", [NSNumber numberWithInteger:2],
        @"true", [NSNumber numberWithBool:YES],
    };

(Note that for the dictionary I took the liberty of [fixing the argument
order]({% post_url 2008-08-23-objective-c-feature-request %}) so that it makes sense to me.)

Creation of NSNumbers is another area that could benefit from the same trick. Although
NSNumber instances can be initialised in lots of different ways, I think this new syntax
sugar should concern itself with just three: `NSInteger`, `double` and `BOOL`. We would
then get this syntax:

    @234    // equivalent to [NSNumber numberWithInteger:234]
    @-14    // equivalent to [NSNumber numberWithInteger:-14]
    @12.0   // equivalent to [NSNumber numberWithDouble:12.0]
    @-0.01  // equivalent to [NSNumber numberWithDouble:-0.01]
    @YES    // equivalent to [NSNumber numberWithBool:YES]
    @NO     // equivalent to [NSNumber numberWithBool:NO]

The initial dictionary creation example would then simply become:

    NSDictionary *dict = @{
        @"one", @1,
        @"two", @2,
        @"true", @YES,
    };

I've filed a feature request with Apple, <rdar://problem/6171253>, I don't
expect, much, that this wish is heeded. A man can dream, though; a man can
dream...

**Update: in 2012, Apple *did* heed this request and implemented static initialisers for
many different types. I only had to wait 4 years :-)**
