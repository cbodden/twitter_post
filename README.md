```

              ::::::::::::.::    .   .::::::::::::::::::::::::::::::.,:::::: :::::::..
              ;;;;;;;;''''';;,  ;;  ;;;' ;;;;;;;;;;;'''';;;;;;;;'''';;;;'''' ;;;;``;;;;
                   [[      '[[, [[, [['  [[[     [[          [[      [[cccc   [[[,/[[['
                   $$        Y$c$$$c$P   $$$     $$          $$      $$""""   $$$$$$c
                   88,        "88"888    888     88,         88,     888oo,__ 888b "88bo,
                   MMM         "M "M"    MMM     MMM         MMM     """"YUMMMMMMM   "W"
                              ::::::::::.    ...      .::::::.::::::::::::
                               `;;;```.;;;.;;;;;;;.  ;;;`    `;;;;;;;;''''
                                `]]nnn]]',[[     \[[,'[==/[[[[,    [[
                                 $$$""   $$$,     $$$  '''    $    $$
                                 888o    "888,_ _,88P 88b    dP    88,
                          mmmmmmmYMMMb     "YMMMMMP"   "YMmMY"     MMM

```

twitter_post
====

twitter image / quote creator and post mechanism


Usage
----
Base usage:
```
git clone git@github.com:cbodden/twitter_post.git
cd twitter_post
mv .twitterpostrc
vi ~/.twitterpostrc
./twitter_post.sh
```

Usage explained:
```
NAME
    ${NAME} - this is for creating and tweeting images with quotes on them

SYNOPSIS
    ${NAME} [-cdhlprs] [-c <path to file>] [-d] [-h hashtags] [-l]
            [-p dir] [-r] [-s time]

DESCRIPTION
    Access your Imgur account from the command line.
    Options can only be used one at a time for now.

    Create an image with comment that are pulled from a local repo.
    Comments can be pulled from either a local file or from fortune.

OPTIONS

    -c [path to file]
            This option is to specify the direct path to the rc file.

    -d      This option defaults to the rc file located at ~.

    -e [1,2,3,4]
            This option controls where the quotes are sourced.
            You must specify one of these at runtime.
            Options:
                1       Shuffle from text file
                2       Use "fortune -s"
                3       Randomize between text file and shuffle
                4       Use your own quote - if used you must specify (-f)

    -f ["quote"]
            This option must be used if you specify (-e 4).

    -h [hashtag(s) / status]
            If either (-c) or (-d) are not specified, this option must be
            specified with either a status or hashtag(s) for twitter.

    -l
            This option keeps the script looping.
            If using this option you must specify (-s).

    -p [path to local dir]
            This option is used if (-c) & (-d) are not used.
            You must specify the path that contains the image dir with
                this option.

    -r
            This option is used with either (-c) or (-d).
            It converts all the images in the images folder into
                a numbered list.

    -s [minutes]
            This option is used with (-l).
            You set the number of minutes used as the range for looping.
                ex.: -s 60
                Means that it will randomely sleep from 1-60 minutes until
                    the next iteration.

    -t
            This option enables testing mode.
            Needs to be used with either (-d) or both (-h) & (-p).

NOTES
    Before running the script run whats below to grant twitter access:
        twurl \
            -u password \
            -p password \
            --consumer-key key \
            --consumer-secret secret
    All the info here can be gotten on twitter or if you follow the twurl
        documentation at : https://github.com/twitter/twurl

    This script uses ~/.twitterpostrc as default but can be changed.
    A sample rc file is in the repo.
```


Requirements
----

- Bash (https://www.gnu.org/software/bash/)
- Imagemagick (http://www.imagemagick.org/)
- Twurl (https://github.com/twitter/twurl)
- npm / ig-upload (https://www.npmjs.com/package/ig-upload)


License and Author
----

Author:: Cesar Bodden (cesar@pissedoffadmins.com)

Copyright:: 2017, Pissedoffadmins.com

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
