#!/bin/bash

status_exit=0;

check_status() {
	eval ${1}
	status=$?
	if [ $status -ne 0 ]; then status_exit=1; fi
	echo "Done and status: $status"
}

# Start

echo -e "\n--------------------"
echo "Sync Backup:"
echo -e "--------------------\n"
kopia repository sync-to sftp --path=/mnt/backup/backup-server --host=freddy-desktop.lan --username=root --keyfile=/root/.ssh/id_rsa --known-hosts=/root/.ssh/known_hosts

echo -e "\n--------------------"
echo "Overall:"
echo -e "--------------------\n"
echo $status_exit

if [ $status_exit -ne 0 ];
then echo "Backup sync failed for ubuntu-server" | sendmail fberg@posteo.de;
fi

exit $status_exit
