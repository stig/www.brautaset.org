---
layout: post
title: Consolidating &amp; de-duplicating iPhoto libraries
tags: [Hacks]
---

This explains how I consolidated & de-duped about 45,000 pictures and movies from four iPhoto libraries on two different machines and various directories full of images on USB drives into one 33,000 file library.

We had about 25,000 photos in one library from a previous (unsuccessful) attempt at consolidating libraries. We had two further libraries containing about 13,000 and 10,000 images each, and a fourth iPhoto library on a separate machine, plus the aforementioned random grab-bag of directories full of images. (I didn't count how many these were, but they numbered in the thousands.) After consolidation we ended up with 33,000 images and movies in one iPhoto library.

iPhoto has a menu item for finding duplicates, but I was not been able to make it work; it would just hang trying to find duplicates in one of the smaller libraries. And even if I could get that to work I didn't have the space to copy all the images into one giant library and let iPhoto sort it out. So I wrote a program to help me.

One problem was that the same picture would exist with different file names, probably due to being imported from devices into multiple different iPhoto libraries or to being exported & then imported again in the aforementioned failed consolidation attempt. We also had different images existing with the same name, due to the counter on the camera looping around. This was OK since iPhoto stores images from different imports in different directories, but it meant that we couldn't just copy all the files into one directory and use the names to de-duplicate them.

I wrote a simple program to iterate over all image & movie files in a directory and create a copy of each named after the [MD5 hash][] of its content. Thus files whose content were identical, but had different names, would now end up with the same name. I did not want to end up with tens of thousands of files in one directory, so I made my program put each file in a directory named after the 2 first characters of each file's name. Here it is:

{% comment %}
#!/bin/sh

set -e
# set -x

src=$1
dst=$2

find "$src" -type f | while read file ; do
    chksum=$(md5 -q "$file")
    dir=$(echo $chksum | cut -b1-2)
    suffix=$(echo $file | awk -F. '{print tolower($NF)}')
    to=$dst/$dir/$chksum.$suffix
    if ! test -f "$to" ; then
        # Make sure destination dir exists...
        mkdir -p $dst/$dir
        link "$file" "$to"
    fi

    log="$chksum $file"
    echo $log >> "$dst/log"
    echo $log
done
{% endcomment %}

<script src="https://gist.github.com/stig/6859521.js">&nbsp;</script>

Since I didn't have enough disk space to duplicate all the images, I used hardlinks. This essentially means you just create a new filename pointing to the same data on disk, without taking up extra data. I also made the program create a log file containing the location of each file and its MD5 hash so I could find out how many files were processed and how many duplicates were found.

A problem with the MD5 hash approach would be if duplicate copies of images had different image metadata. This could be the case is some copies had had their dates adjusted or if iPhoto where changing the EXIF information when you star photos or tag faces in them. Fortunately, a little experimentation showed that iPhoto does not change the image files but stores this extra information in a separate database. My approach would thus mean that we would lose stars & face tags, but we considered this an acceptable trade off. Consolidating and de-duping the libraries would be worth it.

What if the EXIF information *had* been edited? (Some image managers do.) Would all hope be lost? No, it would not. The Imagemagick suite of tools comes with the *identify* program, which allows you to get a hash of just the image data. This would allow us to find more duplicates, even if the EXIF information had been edited; however it runs much, *much* slower than just using MD5 so I chose not to use it.

One worry I had was how to make sure I got hold of all the originals from iPhoto. Due to the aforementioned space constraint I couldn't just export all the photos and thus create new copies. However, this turned out not to be an issue. iPhoto stores its originals in a *Masters* directory, along parallel directories for *Previews* and *Thumbnails*. Thus I just ran my program on the Masters directory. One risk would be losing edits to images, but I was OK with this.

In the end I had 255 directories with on average 130 files in each. I imported these directories into a brand new iPhoto library roughly ten at a time. Since iPhoto doesn't use hardlinks but copies the photos into its library (to avoid nasty surprises if someone decided to edit the file in a different location, no doubt) this ate up disk fast; and I had to delete the existing libraries under the different accounts to make room. Since I had Time Machine backups (yes, plural---I rotate two Time Machine disks) I felt OK doing this.

We are really happy with the result :-)

[md5 hash]: http://en.wikipedia.org/wiki/MD5
