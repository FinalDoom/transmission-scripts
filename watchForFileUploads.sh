#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TRANSMISSION_BASE=/mnt/transmission
UPLOADS_BASE=${TRANSMISSION_BASE}/ToUpload
DOWNLOADS_BASE=${TRANSMISSION_BASE}/Downloads

while :
do
	wait_on -w `find ${UPLOADS_BASE} -type d -depth +0`
	# Wait till file changes stop
	until wait_on -t 1 "`find ${UPLOADS_BASE} -type f -depth +1 | head -n1`"
	do
		sleep 1
	done
	find "$UPLOADS_BASE" -type f -depth +1 -print0 | head -n1 | while IFS= read -r -d '' file; do 
		echo Got new file $file
		IFS=$OLDIFS
		betterfilename=`echo $file | sed -E -e 's/\[(JP|US|AU|v0)\]//gi' -e 's/ *\((TurboSnail|romslab|nsw2u(\.in|\.xyz|\.com)?)\)//gi' -e 's/([A-Za-z0-9])\[/\1 [/g' -e 's/#([^#]+)#/[\1]/gi' -e 's/\]\s+\[/][/g'`
		torrentname="${UPLOADS_BASE}/`basename $betterfilename | sed 's/ /_/g'`.torrent"
		downloadfolder="`dirname "$betterfilename" | sed "s|${UPLOADS_BASE}|${DOWNLOADS_BASE}|g"`"
		echo Renaming file to $betterfilename
		mv "$file" "$betterfilename"
		transmission-create -p -t https://tracker.gazellegames.net/e3c15d2d0a7c1a5a2e24abde2b8d2d32/announce -o "$torrentname" "$betterfilename" >/dev/null 2>&1 && \
		echo Created $torrentname && \
		mv "$betterfilename" "$downloadfolder" || \
		echo Failed to create torrent
		echo
		chown transmission:transmission "$torrentname"
		chmod 660 "$torrentname"
	done
done
