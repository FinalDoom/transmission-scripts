source assertPassword.sh

if [ "$#" -ne 1 ]
then
	echo "Usage: $0 TRACKER_MATCH [INPUT_FILE]" >&2
	exit 1
fi

TRACKER_MATCH="$1"

while read TORRENT_ID
do
	if transmission-remote -ne -t $TORRENT_ID --info-trackers | grep $TRACKER_MATCH -q
	then 
		echo $TORRENT_ID
	fi
done < "${2:-/dev/stdin}"
