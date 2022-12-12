#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/assertPassword.sh

while read TORRENT_ID
do
	transmission-remote -ne -t $TORRENT_ID -i | grep Hash | awk '{ print $2 }'
done < "${1:-/dev/stdin}"
