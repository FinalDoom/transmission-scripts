#!/bin/sh
#
#
. /etc/rc.subr

# Note to self, copy into /usr/local/etc/rc.d/ as transmission_watch_scripts
# Join created screen session with `screen -R TorrentWatch`

name="transmission_watch_scripts"
rcvar="${name}_enable"

start_cmd="${name}_start"
stop_cmd=":"

load_rc_config $name

transmission_watch_scripts_start()
{
    export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/root/bin
    screen -S TorrentWatch -t newTorrents -Adm /mnt/transmission/Customizations/Scripts/watchForNewTorrents.sh && \
    screen -S TorrentWatch -X screen -t fileUploads -Adm /mnt/transmission/Customizations/Scripts/watchForFileUploads.sh&& \
    screen -S TorrentWatch -X screen -t autoUploads -Adm /mnt/transmission/Customizations/Scripts/watchForAutoStartTorrents.sh
}

run_rc_command "$1"
