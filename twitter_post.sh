#!/usr/bin/env bash

#===============================================================================
#          FILE: twitter_post.sh
#         USAGE: ./twitter_post.sh
#   DESCRIPTION: twitter image / quote creator and post mechanism
#       OPTIONS: some so far
#  REQUIREMENTS: bash, twurl, imagemagick
#          BUGS: some
#         NOTES: better documentation in the README file
#        AUTHOR: cesar@pissedoffadmins.com
#  ORGANIZATION: pissedoffadmins.com
#       CREATED: 06 Jul 2017
#      REVISION: 10
#===============================================================================

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
source shlib/img_test.shlib
source shlib/img_tweet.shlib
source shlib/img_gram.shlib
source shlib/cleanup.shlib
source shlib/rename.shlib
source shlib/logd.shlib
source shlib/pause.shlib
source shlib/usage.shlib

## menu selection
while getopts ":c:de:f:h:lp:rs:t" OPT
do
    case "${OPT}" in
        'c')
            ## path to rc file
            if [[ -f "${OPTARG}" ]]
            then
                source ${OPTARG}
            else
                usage
                exit1
            fi
            ;;
        'd')
            ## default option
            _SET_DEF=1
            default
            ;;
		'e')
			## choose fortune, text, or both
			_MAIN=${OPTARG}
			;;
		'f')
			## if using -e, this is needed
			_MAIN_QU=${OPTARG}
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
            _SLEEP=${OPTARG}
            ;;
		't')
			## set test mode
			_TEST=1
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

if [[ "${_TEST}" -eq 1 ]]
then
	main
	img_create
    img_test
	cleanup
    exit 0
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
    if [[ -z "${_SLEEP}" ]]
    then
        usage
        exit 1
    fi

    clear
    printf "\n%s\n" "Beginning ${NAME} loop."

    while :;
    do
        main
        img_create
        img_tweet
        #img_igram
        cleanup
        sleep $(shuf -i 0-${_SLEEP} -n 1)m
    done
fi
