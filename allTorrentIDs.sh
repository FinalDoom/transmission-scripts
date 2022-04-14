source assertPassword.sh

echo "transmission-remote -ne -l | awk '{ print $1 }' | grep -v 'Sum:\|ID' | tr -d '*'"
transmission-remote -ne -l | awk '{ print $1 }' | grep -v 'Sum:\|ID' | tr -d '*'
