source assertPassword.sh

if [ "$#" -ne 1 ]
then
	echo "Usage: $0 TRACKER_MATCHER" >&2
	exit 1
fi

TRACKER_MATCHER="$1"

for TORRENT_ID in $(./trackerTorrentIDs.sh $TRACKER_MATCHER)
do
	transmission-remote -n "$TRANSMISSION_PASSWORD" -t $TORRENT_ID --reannounce
done
