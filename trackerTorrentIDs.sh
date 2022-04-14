source assertPassword.sh

if [ "$#" -ne 1 ]
then
	echo "Usage: $0 TRACKER_MATCH" >&2
	exit 1
fi

TRACKER_MATCH="$1"

for TORRENT_ID in $(./allTorrentIDs.sh)
do
	if transmission-remote -n "$TRANSMISSION_PASSWORD" -t $TORRENT_ID --info-trackers | grep $TRACKER_MATCH -q
	then 
		echo $TORRENT_ID
	fi
done
