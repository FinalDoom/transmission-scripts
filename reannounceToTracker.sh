source assertPassword.sh

while read TORRENT_ID
do
	transmission-remote -ne -t $TORRENT_ID --reannounce
done < "${1:-/dev/stdin}"
