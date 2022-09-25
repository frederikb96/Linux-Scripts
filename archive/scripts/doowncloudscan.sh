#!/bin/bash

Error=0
Adress="pi@192.168.0.129"

usage() { echo "Example to use: doowncloudscan.sh 'Freddy/files/Documents'";
echo "Get Help Message with: doowncloudscan -h";
exit 1; }

while getopts ":h" o; do
case "$o" in

h)
Error=1
;;

:)
echo "No Argument is allowed!"
Error=1
;;

?)
echo "Invalid Option -${OPTARG}"
Error=1
;;

esac
done

if [ $Error -eq 1 ]
then
usage
fi


if [ $# -eq 1  ]
then
echo "Scan the path: $1"
ssh ${Adress} "sudo -u www-data php /var/www/owncloud/occ files:scan -v --path='$1'"
fi
