#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/colors.sh
source $SCRIPT_DIR/assertPassword.sh

for TORRENT_ID in $($SCRIPT_DIR/allTorrentIDs.sh)
do
	percent=`transmission-remote -ne -t $TORRENT_ID -i | grep "Percent Done:" | awk '{ print substr($0,index($0,$3)) }'`
	if [ "$percent" != "100%" ]
	then
		continue
	fi
	status=`transmission-remote -ne -t $TORRENT_ID -i | grep State: | awk '{ print substr($0,index($0,$2)) }'`
	if [ "$status" != "Stopped" ]
	then
		continue
	fi
	directory=`transmission-remote -ne -t $TORRENT_ID -i | grep Location: | awk '{ print substr($0, index($0,$2)) }'`
	name=`transmission-remote -ne -t $TORRENT_ID -i | grep Name: | awk '{ print substr($0,index($0,$2)) }'`
	if [ ! -d "$directory" ]
	then
		echo ID: $TORRENT_ID
		echo -e "${Red}Torrent: ${Reset}${name}${Red} Directory does not exist!${Reset}"
		continue
	fi
	size=`transmission-remote -ne -t $TORRENT_ID -i | grep "Total size:"`
	size_total=`echo $size | awk '{ print $3 " " $4 }'`
	size_wanted=`echo $size | awk '{ print substr($5,2) " " $6 }'`
	pushd $directory > /dev/null
	transmission-remote -ne -t $TORRENT_ID -if | tail -n +3 | awk '{ print substr($0,35) }' | while read line
	do
		if [ ! -f "${directory}/${line}" ]
		then
			echo ID: $TORRENT_ID
			echo "size: $size_total ($size_wanted)"
			if [ "$size_total" == "$size_wanted" ]
			then
				echo -e "${Red}Torrent: ${Reset}${name}${Red} Missing files${Reset}"
			else
				echo -e "${Green}Torrent: ${Reset}${name}${Green} Missing unwanted files ${Reset}"
			fi
			break 1
		fi
	done
	popd > /dev/null
done

