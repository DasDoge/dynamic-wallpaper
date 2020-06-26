#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

## Colors
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
M='\033[1;35m'
C='\033[0;36m'
W='\033[1;37m'

# zsh fix
set -o shwordsplit 2>/dev/null

DIR="/usr/share/dynamic-wallpaper";
TIME="$(date +%k)";
SETTER="wal -qi";

set_wallpaper() {
	image="$DIR/images/$STYLE/$1"
	if [ -f "$image.png" ]; then
		FORMAT="png"
	elif [ -f "$image.jpg" ]; then
		FORMAT="jpg"
	else
		echo -e $R"Invalid theme/style, Try again."; exit 1;
	fi
	if [ $FORMAT ]; then
		$SETTER "$image.$FORMAT"
		return;
	fi
}

main() {
	num=$(($TIME/1))
	set_wallpaper "$num"
}

usage() {
	available_styles=($(ls $DIR/images))
	echo
	echo -e $R"Dynamic Wallpaper V1.0"
	echo -e $G"Simple program to set a dynamic desktop background based on current time."
	echo -e $Y"Developed By - Aditya Shakya (@adi1090x)"
	echo
	echo -e $B"usage: dwall [-s] style [-o] style [-h]"
	echo
	echo -e $M"-s  style     name of theme/style."
	echo -e $M"-o  style     Run once and exit, useful for schedulers (cron)."
	echo -e $M"-h  help      show this usage/help message."
	echo
	echo -e $C"Styles Dir: $DIR/images"
	echo
	printf $G"Available styles/themes:  "
	printf -- $Y'%s  ' "${available_styles[@]}"
	printf -- '\n\n'
}

init() {
	if [ "$RUN_ONCE" == "true" ]; then
		main;
		reset_color;
		exit 0;
	fi
	while true; do
		$DIR/dwall.sh -o $STYLE && sleep 60;
	done
}

is_valid_style() {
	available_styles=($(ls $DIR/images))
	for i in "${available_styles[@]}"; do
		[ "$i" == "$1" ] && STYLE=$(echo "$1")
	done
}

reset_color() {
	tput sgr0 # reset attributes
	tput op # reset color
}

is_valid_style "$1"

while getopts ":s:o:h" opt; do
	case ${opt} in
	s )
		RUN_ONCE=false
		STYLE=$OPTARG
		;;
	o )
		RUN_ONCE=true
		STYLE=$OPTARG
		;;
	h )
		usage
		reset_color
		exit 0
		;;
	\?)
		echo -e $R"Unknown option,$G run dwall -h"
		reset_color
		exit 1
		;;
	: )
		echo -e $R"Invalid:$G -$OPTARG$R requires an argument."
		reset_color
		exit 1
		;;
	esac
done

if [ "$STYLE" ]; then
	init
else
	usage
	reset_color
fi
