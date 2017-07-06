#!/usr/bin/env bash

function main()
{
    ## images directory local to this script
    _IMG_DIR="images/"

    ## text file
    _TXT_FILE="twitter_post.txt"

    ## grab random image
    _IMG_SHUF=$(shuf -n1 -e ${_IMG_DIR}* \
        | cut -d"/" -f2)
    _IMG=${_IMG_DIR}${_IMG_SHUF}
    _IMG_EXT=${_IMG##*.}

    ## grab random line from text file
    _TXT_SHUF=$(shuf -n1 ${_TXT_FILE})
    _TXT=${_TXT_SHUF}

    ## use image width for caption shade below
    _WDTH=$(identify -format %w ${_IMG})
}

function img_create()
{
    ## put text on image
    convert -background '#0008' \
        -fill white \
        -gravity center \
        -size ${_WDTH}x30 \
        caption:"${_TXT}" \
        -font Helvetica \
        -pointsize 20 \
        ${_IMG} \
        +swap \
        -gravity center \
        -composite test.${_IMG_EXT}

    ## standardize all output images to jpg and same name plus rm others
    convert test.${_IMG_EXT} upload.jpg
    rm test.${_IMG_EXT}
}

function img_tweet()
{
    ## before fully uploading with twurl, run this with info changed
    ## in the command line so that twurl will work
    #twurl \
        #    authorize \
        #    -u username \
        #    -p password \
        #    --consumer-key key \
        #    --consumer-secret secret

    ## upload and generate media_id_string
    twurl \
        -H upload.twitter.com "/1.1/media/upload.json" \
        -f upload.jpg \
        -F media \
        -X POST \
        > _json.out

    ## parse out "media_id_string" to pass to post
    _M_ID=$(python -m json.tool _json.out \
        | grep "media_id_string" \
        | cut -d":" -f2 \
        | sed 's/[",]//g' \
        | tr -d " ")

    ## post
    twurl \
        "/1.1/statuses/update.json" \
        -d "media_ids=${_M_ID}" \
        -d "status=#${_TXT}"
}

function cleanup()
{
    mv upload.jpg posted/$(echo $(date "+%Y%m%d_%H%M%S").jpg)
}


main
img_create
img_tweet
cleanup
