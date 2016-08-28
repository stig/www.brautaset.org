---
title: Setting up Leafnode NNTP server on OS X
layout: post
abstract: I set up the Leafnode NNTP server on OS X, for use with Emacs and the  Gnus newsreader.
---

**Note: Although this works, I don't actually use Leafnode any more. I now use the [Gnus Agent](https://www.gnu.org/software/emacs/manual/html_node/gnus/Agent-Basics.html) instead.**

I read email and news with Gnus. I often use a laptop, and often in places I
don't have internet access. Gnus doesn't like not being able to connect to the
nntp server when it starts, so as a work-around I run the
[Leafnode](http://leafnode.sourceforge.net) NNTP server locally. As a nice
side effect, Gnus starts a lot faster.

I use [Orgmode](http://orgmode.org) and have a
[Leafnode.org](https://github.com/stig/dot-files/blob/master/Leafnode.org)
that all the configuration is generated from. If you use Emacs, and Orgmode,
you probably want to just look at that directly. If you use some other NNTP
client you might want to read this post instead. No Emacs required :-)

# Installation

First we have to install Leafnode. This is dirt simple with
[homebrew](http://brew.sh):

```sh
brew install leafnode
```

# Configuration

Configuring Leafnode is also quite simple really. The action all takes place
in the `/usr/local/etc/leafnode/config` file. You have to create this file,
but there's very few required settings and there's a well-commented example at
`/usr/local/etc/leafnode/config.example` that we can use as a reference. I'll
omit comments from my version. Here's my config file. You obviously have to
change `hostname` to suit you.

```conf
expire = 20
server = news.gmane.org
initialfetch = 100
hostname = yourhost.yourdomain.com
```

# A note on users

Leafnode keeps going on about having to create a separate user to run
Leafnode. This might make sense in a multi-user setup, but for a single-user
case on my laptop it's overkill---so I don't bother. 


# Scheduling

Leafnode is not just one program, but a collection of programs. The three
important daemons (programs) are:

- **fetchnews:** posts to and fetches articles from upstream.
- **leafnode:** the nntp server that Gnus interacts with.
- **texpire:** a periodic job that cleans up old / obsolete news.

We need to configure these to run periodically. Since we're on OS X we'll use
launchd. I've cribbed heavily from
[the Leafnode macports package](https://trac.macports.org/browser/trunk/dports/news/leafnode/files)
for these config files.

The files below all go in the `~/Library/LaunchAgents` directory.

## Fetchnews

Let's run this every 30 minutes to push outgoing posts to and fetch new
articles from upstream. This file is called `org.brautaset.fetchnews.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <false/>
    <key>Label</key>
    <string>org.brautaset.fetchnews</string>
    <key>Program</key>
    <string>/usr/local/sbin/fetchnews</string>
    <key>StartInterval</key>
    <integer>1800</integer>
    <key>WorkingDirectory</key>
    <string>/usr/local/var/spool/news</string>
  </dict>
</plist>
```

## Leafnode

Next we need to make sure that Leafnode runs when anyone (Gnus) attempts to
connect to the news server. It is best to launch it on demand, so it does not
require resources when we are not reading news. This file is called
`org.brautaset.leafnode.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>OnDemand</key>
    <true/>
    <key>Label</key>
    <string>org.brautaset.leafnode</string>
    <key>WorkingDirectory</key>
    <string>/usr/local/var/spool/news</string>
    <key>Program</key>
    <string>/usr/local/sbin/leafnode</string>
    <key>Sockets</key>
    <dict>
      <key>Listeners</key>
      <dict>
        <key>SockServiceName</key>
        <string>nntp</string>
      </dict>
    </dict>
    <key>inetdCompatibility</key>
    <dict>
      <key>Wait</key>
      <false/>
    </dict>
  </dict>
</plist>
```

## Texpire

We'll run it about every 7 hours, which means that on successive days it
should run at different times of day. I do this so that there's a bigger
chance it *eventually* will run at a time the computer is on. This file is
called `org.brautaset.texpire.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <false/>
    <key>Label</key>
    <string>org.brautaset.texpire</string>
    <key>Program</key>
    <string>/usr/local/sbin/texpire</string>
    <key>StartInterval</key>
    <integer>25000</integer>
    <key>WorkingDirectory</key>
    <string>/usr/local/var/spool/news</string>
  </dict>
</plist>
```

## Start the services

Because we put the launchd config files in `~/Library/LaunchAgents` they
should be automatically loaded at login, so you shouldn't have to think
about it. However, you probably don't want to logout and back in again just
to load them. Luckily you can run this command to load them manually now:

```sh
launchctl load ~/Library/LaunchAgents/org.brautaset.{fetchnews,texpire,leafnode}.plist
```

If you used your own domain name in the name of the files you obviously also
have to change the above command.

# Closing notes

I hope you found this useful. I know I would have when I was trying to set
this up a few weeks ago!
