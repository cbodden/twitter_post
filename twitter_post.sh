#!/usr/bin/env bash

LC_ALL=C
LANG=C
NAME=$(basename $0)

RED=$(tput setaf 1)
BLU=$(tput setaf 4)
GRN=$(tput setaf 40)
CLR=$(tput sgr0)

source shlib/default.shlib
source shlib/main.shlib
source shlib/img_create.shlib
source shlib/img_tweet.shlib
source shlib/img_gram.shlib
source shlib/cleanup.shlib
source shlib/_RENAME.shlib
source shlib/logd.shlib
source shlib/pause.shlib
source shlib/usage.shlib

## menu selection
while getopts "dh:lp:rs:" OPT
do
    case "${OPT}" in
        'd')
            ## default option
            _SET_DEF=1
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
            _RNM=1
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
shift $((OPTIND-1))

if [[ "${_SET_DEF}" -ne "1" ]]
then
    if [[ -z "${_L_DIR}" ]] || [[ -z "${HASHTAG}" ]]
    then
        usage
        exit 1
    fi
fi



if [[ "${_RNM}" -eq 1 ]]
then
    _RENAME
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
