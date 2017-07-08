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
#      REVISION: 45
#===============================================================================

LC_ALL=C
LANG=C
readonly NAME=$(basename $0)
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

readonly RED=$(tput setaf 1)
readonly BLU=$(tput setaf 4)
readonly GRN=$(tput setaf 40)
readonly CLR=$(tput sgr0)

## sourcing shlibs
_SRC_SHLIB="cleanup default img_create img_gram img_test img_tweet info logd \
	main pause rename usage"
for ITER in ${_SRC_SHLIB}
do
	source ${PROGDIR}/shlib/${ITER}.shlib
done

## menu selection
readonly OPTIONS=":c:de:f:h:lp:rs:tv"
while getopts "${OPTIONS}" OPT
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
		'v')
			## show version info
			_info
			exit 0
			;;
	esac
done

if [ $OPTIND -eq 1 ]
then
	usage
	exit 0
fi

shift $((OPTIND-1))

main
