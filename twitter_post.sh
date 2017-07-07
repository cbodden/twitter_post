#!/usr/bin/env bash

LC_ALL=C
LANG=C
NAME=$(basename $0)

RED=$(tput setaf 1)
BLU=$(tput setaf 4)
GRN=$(tput setaf 40)
CLR=$(tput sgr0)

function default()
{
    ## check and source config file
    if [[ -e ~/.twitterpostrc ]]
    then
        source ~/.twitterpostrc
    else
        printf "%s\n" \
            "Config file not found" \
            "Exiting"
        exit 1
    fi
}

function main()
{
    ## images directory local to this script
    _IMG_DIR="${_L_DIR}images/"

    ## text file
    _TXT_FILE="${_L_DIR}twitter_post.txt"

    ## grab random image
    _IMG_SHUF=$(basename $(shuf -n1 -e ${_IMG_DIR}*))
    _IMG=${_IMG_DIR}${_IMG_SHUF}
    _IMG_EXT=${_IMG##*.}

    ## grab random line from text file or fortune
    arr[0]="$(shuf -n1 ${_TXT_FILE})"
    arr[1]="$(fortune -s)"
    rand=$(( RANDOM % 2 ))
    # echo ${arr[$rand]}
    # _TXT_SHUF=$(shuf -n1 ${_TXT_FILE})
    _TXT_SHUF=$(echo ${arr[$rand]})
    _TXT=${_TXT_SHUF}
}

function img_create()
{
    ## convert images wider than 1300 to 50%
    if [[ "$(identify ${_IMG} | awk '{print $3}' | cut -dx -f1)" -gt "1300" ]]
    then
        convert -resize 50% ${_IMG} ${_L_DIR}resized.${_IMG_EXT}
        _IMG=${_L_DIR}resized.${_IMG_EXT}
    fi

    ## use image width for caption shade below
    _WDTH=$(identify -format %w ${_IMG})
    if [[ "${_WDTH}" -lt "$(identify -format %h ${_IMG})" ]]
    then
        _HGHT=$(identify -format %w ${_IMG})
    else
        _HGHT=$(identify -format %h ${_IMG})
    fi

    ## put text on image
    convert -background '#0008' \
        -fill white \
        -gravity center \
        -size $((${_WDTH}-20))x$((${_HGHT}/10)) \
        caption:"${_TXT}" \
        -font Helvetica \
        ${_IMG} \
        +swap \
        -gravity center \
        -composite ${_L_DIR}test.${_IMG_EXT}

    ## standardize all output images to jpg and same name plus rm others
    convert ${_L_DIR}test.${_IMG_EXT} ${_L_DIR}upload.jpg
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
        -f ${_L_DIR}upload.jpg \
        -F media \
        -X POST \
        > ${_L_DIR}_json.out

    ## parse out "media_id_string" to pass to post
    _M_ID=$(python -m json.tool ${_L_DIR}_json.out \
        | grep "media_id_string" \
        | cut -d":" -f2 \
        | sed 's/[",]//g' \
        | tr -d " ")

    ## post
    twurl \
        "/1.1/statuses/update.json" \
        -d "media_ids=${_M_ID}" \
        -d "status=${HASHTAG}" \
        > /dev/null
}

function img_igram()
{
    ## before uploading with ig-upload you need to run it like so:
    ## ig-upload login
    ## then you can run the bottom

    ## upload and hashtag
    ig-upload ${_L_DIR}upload.jpg "${HASHTAG}"
}

function cleanup()
{
    mv \
        ${_L_DIR}upload.jpg \
        ${_L_DIR}posted/$(echo $(date "+%Y%m%d_%H%M%S").jpg)
    # rm ${_L_DIR}upload.jpg 2> /dev/null
    rm ${_L_DIR}test.${_IMG_EXT} 2> /dev/null
    rm ${_L_DIR}resized.${_IMG_EXT} 2> /dev/null
}

function _RENAME()
{
    PTH="${_L_DIR}images/"

    _DIR_CNT=$(ls -l ${PTH} \
        | egrep -c '^-')

    if [ "$_DIR_CNT" -lt "1000" ]
    then
        _MASK="%04d"
    else
        _MASK="%05d"
    fi

    for FILE in ${PTH}*
    do
        NUM=$(prntf "${_MASK}.${FILE##*.}" "${CNT}")
        _FILE_TST=$(echo ${FILE%%.*} \
            | sed 's/^.*\///')
        if [ "${_FILE_TST}" != "${NUM%%.*}" ]
        then
            printf "%s\n" \
                "Moving ${RED}${FILE}${CLR} to ${BLU}${PTH}${NUM}"
            printf "${CLR}"
            mv -n "${FILE}" "${PTH}${NUM}"
        else
            printf "%s\n" \
                "Not moving ${GRN}${FILE}${CLR}"
            printf "${CLR}"
        fi
        let CNT=$CNT+1
    done
}

function usage()
{
    echo
}

## menu selection
while getopts "dh:lp:rs:" OPT
do
    case "${OPT}" in
        'd')
            ## default option
            default
            ;;
        'h')
            ## hashtag / status
            HASHTAG=${OPTARG}
            ;;
        'l')
            ## daemonize / loop / put in the background
            _DAEM=1
            ;;
        'p')
            ## local dir
            _L_DIR=${OPTARG}
            ;;
        'r')
            ## rename images into numbered list
            _RENAME
            ;;
        's')
            ## sleep range
            __SLEEP=${OPTARG}
            ;;
        *)
            usage \
                | less
            exit 0
            ;;
    esac
done

if [[ ${OPTIND} -eq 1 ]]
then
    # usage
    exit 0
fi
shift $((OPTIND-1))

if [[ -z "${_L_DIR}" ]]
then
    # usage
    exit 0
fi

if [[ -z "${HASHTAG}" ]]
then
    # usage
    exit 0
fi

if [[ "${_DAEM}" -ne "1" ]]
then
    main
    img_create
    img_tweet
    #img_igram
    cleanup
else
    _TMPPID="$$"
    case $(ps -o stat= -p $$) in
        *+*)
            ## if running in foreground
            exec $0 $ disown $!
            kill -9 ${_TMPPID} 2>&1
            ;;
        *)
            ## if running in background
            ;;
    esac

    while :;
    do
        main
        img_create
        img_tweet
        #img_igram
        cleanup
        sleep $(shuf -i 0-${_SLEEP} -n 1)
    done

fi
