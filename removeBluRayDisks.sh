#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/assertPassword.sh

$SCRIPT_DIR/allTorrentIDs.sh | while read TORRENT_ID
do
	directory=`transmission-remote -ne -t $TORRENT_ID -i | grep Location: | awk '{ print substr($0, index($0,$2)) }'`
	if transmission-remote -ne -t $TORRENT_ID -if | tail -n +3 | awk '{ print substr($0,35) }' | grep --quiet /BDMV/
	then
		if transmission-remote -ne -t $TORRENT_ID -i | grep Labels | grep --quiet Automated
		then
			if transmission-remote -ne -t $TORRENT_ID -i | grep --quiet 'Percent Done: 0.0%'
			then
				transmission-remote -ne -t $TORRENT_ID --remove-and-delete
			fi
		fi
	fi
done

