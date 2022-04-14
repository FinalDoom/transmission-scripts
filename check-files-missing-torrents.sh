source colors.sh
source assertPassword.sh

rm /tmp/torrent-files.txt 2> /dev/null

echo "Listing files in all torrents" >&2
./allTorrentIDs.sh | while read TORRENT_ID
do
	directory=`transmission-remote -ne -t $TORRENT_ID -i | grep Location: | awk '{ print substr($0, index($0,$2)) }'`
	transmission-remote -ne -t $TORRENT_ID -if | tail -n +3 | awk '{ print substr($0,35) }' | while read line
	do
		echo "${directory}/${line}" >> /tmp/torrent-files.txt
	done
done

echo "Comparing to filesystem" >&2
echo >&2

find ${1:-/mnt/transmission/Downloads} -type f ! -name "*.part" | grep -Fxvf /tmp/torrent-files.txt

#rm /tmp/torrent-files.txt 2> /dev/null
