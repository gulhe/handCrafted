#!/usr/bin/env bash

function usage {
	echo "The convinient em$($1 -r 1 grinning face)ji finder for your cli $($1 -r 1 Man Technologist)"
	echo "${1}'s usage:"
	echo "${1} {-d|--debug} {-c|--copy} {-r|--raw} [QUERY] {[Nth]}"
	echo '---------------------'
	echo 'QUERY:'
	echo ' What you are looking for'
	echo '---------------------'
	echo 'ARGS:'
	echo ' -d/--debug:'
	echo '    shows every gotten line from the source before processing (for html tag lover but, mostly, for debugging purpose)'
	echo ' Nth (NUMERIC):'
	echo '    when specified, limits the output to the nth result, behaviour is not guaranted if you specified a Nth out of the bounds of the result ... dezo pas dezo ...'
	echo ' -c/--copy:'
	echo '    copies the last outputed line to the clipboard (proTip: works best with the `Nth` option ...)'
	echo ' -r/--raw:'
	echo '    only outputs the emoji and not his name nor any fancy display-related shennanigans (NB: much like --copy, it is meant to be used with `Nth`)'
}

getopt --test > /dev/null
if [[ ${?} -ne 4 ]]; then
	echo "I’m sorry, `getopt --test` failed in this environment."
	exit 1
fi

OPTIONS='rdcuh'
LONGOPTS='copy,raw,debug,usage,help'

# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=+${OPTIONS} --longoptions=${LONGOPTS} --name "$0" -- "$@")
if [[ ${?} -ne 0 ]]; then
	# e.g. return value is 1
	#  then getopt has complained about wrong arguments to stdout
	usage $0
	exit 2
fi
# read getopt’s output this way to handle the quoting right:

eval set -- "${PARSED}"

re='^[0-9]+$'

copy=false
raw=false
debug=false
nth=0
query=''

# now enjoy the options in order and nicely split
while [[ $1 ]] ; do
	if [[ $1 =~ $re ]]
	then
		nth=$(($nth+$1))
	else
		case "$1" in
			-u|-h|--usage|--help)
				usage $0
				exit 0
				;;
			-c|--copy)
				copy=true
				;;
			-r|--raw)
				raw=true
				;;
			-d|--debug)
				debug=true
				;;
			--)
				;;
			*)
				if [ "$query" != "" ]
				then
					query="$query%20"
				fi
				query="$query$1"
				;;
		esac
	fi
	shift
done

curl https://emojipedia.org/search/?q=$query 2>/dev/null | grep 'h2' | grep 'emoji'|grep 'class' > /tmp/emojojo
if [[ $nth -ne 0 ]]
then
	cat /tmp/emojojo | head -n $nth | tail -n 1 > /tmp/emojojon
	mv /tmp/emojojon /tmp/emojojo
fi

while read line
do
	if $debug
	then
		echo "[DEBUG] $line"
	fi
	output=$(echo $line | awk -F'"emoji">' '{print $2}' |awk -F'</' '{print $1}' | xargs)
	if [ "$raw" = false ]
	then
		output="$output : $(echo $line | awk -F'span>' '{print $2}' |awk -F'</' '{print $1}' | xargs)"
	fi
	if $copy
	then
		echo -n $output | xclip -selection c
	else
		echo $output
	fi
done </tmp/emojojo
