source assertPassword.sh

while read TORRENT_ID
do
	transmission-remote -n "$TRANSMISSION_CREDENTIALS" -t $TORRENT_ID -SR
done < "${1:-/dev/stdin}"
