#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TRANSMISSION_HOME=/usr/local/etc/transmission/home
TORRENTS_DIR=${TRANSMISSION_HOME}/torrents

while :
do
	wait_on -w "${TORRENTS_DIR}"
	sleep 5
	$SCRIPT_DIR/mostRecentTorrents.sh 10 | $SCRIPT_DIR/trackerTorrentIDs.sh gazellegames\\.net\|beyond-hd\\.me\|animebytes\\.tv\|archive\\.org\|bemaniso\\.ws\|ehtracker\\.org\|empornium\\.sx\|flacsfor\\.me\|jpopsuki\\.eu\|myanonamouse\\.net\|oppaiti\\.me | $SCRIPT_DIR/removeTrackerSeedRatio.sh
done
