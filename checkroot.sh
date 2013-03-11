#! /bin/bash
#  Check if there is enough available disk space on root partition (more than 10M).
#  If there isn't, it will close and delete NetworkManager's connection, so it won't start again, untill the user comes, knows about it and restores the backups

# Set the least root partition size here
least=10

function downcon() {
    for i in `nmcli con status | grep -oP "\S+-\S+-\S+-\S+-\S+"`; do
	nmcli con delete uuid "$i"
	nmcli con down uuid "$i"
    done
}

while :; do
    size="$( df -B 1M | grep -E "/$" | awk '{ print $4 }' )"
    if [ "$size" -lt "$least" ]; then
	downcon
	zenity --error --title "Error" --text "There's less then 10M left on your root partition.\nYour internet connection is down and deleted.\nThere should be a backup at ~/.nm-cons-bac. Copy all the files in the directory to /etc/NetworkManager/system-connections when you make sure you have enough disk space on your root partition (10M at least)"
    fi
    sleep 10s
done
