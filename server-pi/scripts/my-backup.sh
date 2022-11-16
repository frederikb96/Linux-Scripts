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
echo "Scripts:"
echo -e "--------------------\n"
check_status "kopia snapshot create /root/scripts"

echo -e "\n--------------------"
echo "Docker:"
echo -e "--------------------\n"
check_status "kopia snapshot create /opt/docker"

echo -e "\n--------------------"
echo "Status:"
echo -e "--------------------\n"
kopia snapshot list -a

echo -e "\n--------------------"
echo "Overall:"
echo -e "--------------------\n"
echo $status_exit

if [ $status_exit -ne 0 ];
then echo "Backup failed for pi" | sendmail fberg@posteo.de;
fi

exit $status_exit
