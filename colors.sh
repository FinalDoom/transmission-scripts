#!/usr/bin/env bash

# Command info: https://www.freebsd.org/cgi/man.cgi?query=terminfo&sektion=5
# Why was this so hard to find?

set -o nounset

tput_init_linux() {
	set_fg_color='tput setaf'
	set_bg_color='tput setab'
	blink_color=$(tput blink 2>/dev/null)
	bold_color=$(tput bold 2>/dev/null)
	reset_color=$(tput sgr0 2>/dev/null)
	underline_color=$(tput smul 2>/dev/null)
}
tput_init_bsd() {
	set_fg_color='tput AF'
	set_bg_color='tput AB'
	blink_color=$(tput mb 2>/dev/null)
	bold_color=$(tput md 2>/dev/null)
	reset_color=$(tput me 2>/dev/null)
	underline_color=$(tput us 2>/dev/null)
}
tput_init_none() {
	set_fg_color=':'
	set_bg_color=':'
	blink_color=
	bold_color=
	reset_color=
	underline_color=
}

if tput setaf 1 >/dev/null 2>&1; then tput_init_linux || tput_init_none;
elif tput AF 1  >/dev/null 2>&1; then tput_init_bsd   || tput_init_none;
else tput_init_none; fi

# Special
BLINK=$blink_color
BOLD=$bold_color
RESET=$reset_color
UNDERLINE=$underline_color

# Foreground
BLACK=`$set_fg_color 0`
RED=`$set_fg_color 1`
GREEN=`$set_fg_color 2`
YELLOW=`$set_fg_color 3`
BLUE=`$set_fg_color 4`
MAGENTA=`$set_fg_color 5`
CYAN=`$set_fg_color 6`
WHITE=`$set_fg_color 7`

# Background
BGBLACK=`$set_bg_color 0`
BGRED=`$set_bg_color 1`
BGGREEN=`$set_bg_color 2`
BGYELLOW=`$set_bg_color 3`
BGBLUE=`$set_bg_color 4`
BGPURPLE=`$set_bg_color 5`
BGCYAN=`$set_bg_color 6`
BGWHITE=`$set_bg_color 7`
