---
layout: post
title: Untraditional Refactoring Technique
imported: 31/01/2013
---

Bizzarely, today I found myself deleting a test script preparing to refactor the code it
tested. Really.

Before you proceed to tear your hair out, let me just say that it's not actually as crazy
as it sounds, however. The project in question is a forked and cut-down version of a
project with much wider scope. Therefore it has lots of code in it that is not exercised
by the consumers of the API it provides, but only of its own tests.

The particular test I deleted was checking to see whether all the Perl modules in the
project actually compiles. By removing it we can simply prune modules that are not even
loaded off disk. The test coverage report I'm going is produced by running the project's
unit-tests as well as running all the other individual projects against it. Our build
system checks all of these out of subversion for the builds, hence I could not simply omit
to run the offending test.

OK, so this is not *really* a refactoring, but simply a way of deleting dead code.
Refactoring is a *much* hotter buzzword though, so I wanted to squeeze it into the title
of this post somehow. Once the effort of removing the dead code is over I'll add the test
back in.
