source assertPassword.sh

transmission-remote -n "$TRANSMISSION_PASSWORD" -l | awk '{ print $1 }' | grep -v 'Sum:\|ID' | tr -d '*'
