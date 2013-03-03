---
layout: post
title: Embedding Cocoa Frameworks
tags: [Development]
---

Cocoa has a really neat feature that allows you to embed a framework inside your
application bundle. Why would you want to do this? Not all frameworks are available
everywhere. Instead of forcing your users to install lots of frameworks before they can
start using your app, simply bundle them inside your app.

You cannot simply embed any framework; it has to be built specifically for embedding. A
framework is a dynamically linked library. These have the path they are installed at
hardcoded inside them. (For security reasons, or some such; it's damn inconvenient at any
rate.) Normally these paths are of the form `/Library/Frameworks/`. For an embedded
framework, however, we have to use something else. The special path `@executable_path`
refers to the path of the executable inside your application bundle. You can then refer to
the `Frameworks` directory in your application bundle by setting the installation path of
your framework to be `@executable_path/../Frameworks`.

<img src="/images/2007/09/install-path.png" alt="install_path.png" />

If you want to embed a framework inside another framework you'll need the even more
special `@loader_path`, which is only available in OS X 10.4 Tiger and later. I find this
useful, so that's what I used in the example above. Now add the framework to your
application the way you'd add any other existing framework:

<img src="/images/2007/09/add-existing-framework.png" alt="add_existing_framework.png" />

Add a "copy files" build phase and chose destination `Frameworks`. Drag the embedded
framework you added into it.

<img src="/images/2007/09/copy-files-build-phase.png" alt="copy_files_build_phase.png" />

Voil&aacute;!


*Jonathan "Wolf" Rentzsch has a <a
href="http://rentzsch.com/cocoa/embeddedFrameworks">screencast</a> that shows you in more
detail how to embed frameworks. It is for a rather older version of Xcode than what is
available now, but it is still good. The Cocoa developer guide to <a
href="http://developer.apple.com/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/
CreatingFrameworks.html%23//apple_ref/doc/uid/20002258-106880-BAJJBIEF">embedding a
framework</a> is also good.*
