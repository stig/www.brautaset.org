---
layout: post
title: Piping to sh -
imported: 31/01/2013
tags: [Hacks]
---

So, in a [previous post][previous] I showed how to rename lots of files with little
effort. Let's remind ourselves how the one-liner looks:

[previous]: {% post_url 2007-06-11-renaming-lots-of-files %}

    for f in *.doc ; do mv $f ${f%.doc}.txt ; done

Imagine that you *haven't* done that kind of transformation a thousand times and so feel
a bit apprehensive about diving right in. The standard way to get around that is to
pre-pend the command with echo:

    for f in *.doc ; do echo mv $f ${f%.doc}.txt ; done

Now, instead of performing a lot of renames, your loop will just print out the commands it
would do if the echo was not there. When you've looked over the output and satisfied that
it will do what you want, you have to options. You can either edit the command to remove
the `echo`, or you can pipe the result to `sh -`; the latter being my favourite:

    for f in *.doc ; do echo mv $f ${f%.doc}.txt ; done | sh -

The pipe, for those who haven't encountered it, means that the output of the command to
the left of it is used as input for the command to the right. The `sh` command is just a
shell (similar to the one you're typing these commands into; on your system, it's probably
an alias for bash or zsh), and invoking it with the argument '-' means that it should read
commands from its standard input and execute each line. Simple!
