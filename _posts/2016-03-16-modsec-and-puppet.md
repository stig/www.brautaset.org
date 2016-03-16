---
layout: post
title: ModSecurity and Puppet Spelunking
tags: [Operations]
---

This week I have made my first (non-README) contribution to a puppet module.

I was attempting to configure [ModSecurity](https://github.com/SpiderLabs/ModSecurity) using the puppetlabs-apache puppet
module when I discovered that the `/var/log/httpd/modsec_audit.log` file
contained the request body for rejected requests. For PCI-DSS reasons, this
was not desirous, so I set out to learn how I could configure ModSecurity to
stop doing that.

First I consulted the [ModSecurity audit log](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual#SecAuditLogParts) documentation and learnt that you
can choose which sections to include in the audit log with the
`SecAuditLogParts` directive. Helpfully the audit log file contains section
separators (e.g. `--be604c0a-C--`) which have a section identifier&#x2014;in this
case `C`&#x2014;which corresponds to the "request body" part. So, all I had to do
was ensure that I removed `C` from the `SecAuditLogParts` directive. Simples!

There was just one *teeeny tiny* problem. My `/etc/httpd/conf.d/security.conf`
contained the below line, and *look ma*, no `C` to be seen. Drat.

    SecAuditLogParts ABIJDEFHZ

My first thought was that perhaps my config file was not read and ModSecurity
was running with its defaults, which are documented to be `ABCFHZ`. Or perhaps
there was an error in the config file further up so it was only partly read<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup>.
To test this I changed the `SecAuditLog` directive (which was the last
directive in the file) and restarted Apache. I provoked ModSecurity again, and
lo and behold it logged to the audit log with the new name. So at least I had
confirmed that the config file was read.

I also discovered that my audit log had the `E` section in them, which is
*not* in the default, so I went back to re-read the documentation for the
audit log sections. I won't bother you with details of how my lips moved when
carefully reading the text, but here's our culprit:

> -   **I**: This part is a replacement for part C. It will log the same data as C in
>     all cases except when multipart/form-data encoding in used. In this case, it
>     will log a fake application/x-www-form-urlencoded body that contains the
>     information about parameters but not about the files. This is handy if you
>     don’t want to have (often large) files stored in your audit logs.

Using the `C` section identifier in the log file when all the other sections
map directly from the section part selector to the section identifier is
unintuitive, to say the least. I wasted quite a lot of time because of this
and [filed an issue](https://github.com/SpiderLabs/ModSecurity/issues/1089) about it. I wouldn't be surprised if it is never fixed as
third-party tools rely on the current behaviour though.

Moving on! I now had a plan. All I had to do was remove the `I` part selector
from the `SecAuditLogParts` directive. Unfortunately this was not configurable
through `puppetlabs-apache`. It was hardcoded in the `security.conf.erb`
template. The plan now became "moaning to friends" about my situation. In
private<sup><a id="fnr.2" class="footref" href="#fn.2">2</a></sup>.

Turns out I moaned to the right friends. After receiving some encouragement
and pointers from [Dean Wilson](http://unixdaemon.net) I set out to contribute the ability to configure
which sections you want printed to the `modsec_audit.log` file to
`puppetlabs-apache`. It was much simpler than I thought, and culminated in a
[pull request](https://github.com/puppetlabs/puppetlabs-apache/pull/1392) that was merged pretty swiftly.

If you're thinking: "that's cool. I could use that actually. What do I have to
do?" then don't worry&#x2014;I've got your back! It may be a little while before
there's a [new release](https://github.com/puppetlabs/puppetlabs-apache/releases), but if you use [librarian-puppet](http://bombasticmonkey.com/librarian-puppet/) to manage your puppet
modules you can easily install the tip of the current master branch by putting
this in your `Puppetfile`:

    mod 'puppetlabs-apache',
      :git => 'https://github.com/puppetlabs/puppetlabs-apache.git'

You can then select which sections you want printed to the `modsec_audit.log`
file by putting something like this in a relevant hiera file:

    apache::mod::security::audit_log_parts: ABZ

If you don't use hiera, you can set it directly from a puppet manifest like
so:

    class { '::apache::mod::security':
      audit_log_parts => 'ABZ'
    }

By the way, *please* do not blindly copy `ABZ` from the above example, but
refer to the [audit log](https://github.com/SpiderLabs/ModSecurity/wiki/ModSecurity-2-Data-Formats#audit-log) documentation and make an informed choice as to which
sections you want to log to *your* audit log. Every app is different and
what's right for mine is not necessarily right for yours. (Especially since
that isn't actually what I use: I just felt it rolled off the tongue nicely
for this example, if you pronounce the `Z` like a `C`, as some are wont.)

<div id="footnotes">
<h2 class="footnotes">Footnotes: </h2>
<div id="text-footnotes">

<div class="footdef"><sup><a id="fn.1" class="footnum" href="#fnr.1">1</a></sup> <div class="footpara">Although I judged the chance of the latter slim, since no warnings or
errors were logged about corrupt config.</div></div>

<div class="footdef"><sup><a id="fn.2" class="footnum" href="#fnr.2">2</a></sup> <div class="footpara">I am a grown-up, and a professional, after all.</div></div>


</div>
</div>
