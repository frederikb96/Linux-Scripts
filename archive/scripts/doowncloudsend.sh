#!/bin/bash

#--------------------
#Help
#--------------------

help=0

usage() {
echo "Get Help Message with: doowncloudsend.sh -h";
echo "Source Path like: /home/freddy/Pictures/2021";
echo "Destination path like: Freddy/files/Pictures/";
echo "Scan Folder like: Freddy/files/Pictures/2021";
echo "Example to use: doowncloudsend.sh '/home/freddy/Pictures/2021' 'Freddy/files/Pictures/' 'Freddy/files/Pictures/2021'";
exit 1; }

while getopts ":h" o; do
case "$o" in

h)
help=1
;;

:)
echo "No Argument is allowed!"
help=1
;;

?)
echo "Invalid Option -${OPTARG}"
help=1
;;

esac
done

if [ $help -eq 1 ]; then usage; fi

if [ $# -ne 3 ]; then echo "Three Arguments needed!"; usage; fi


#--------------------
#Main
#--------------------

Adress="pi@192.168.0.129"
ownclouddata="/mnt/owncloud/ownclouddata/"

echo "Go"
rsync -rtPhv --rsync-path="sudo rsync" $1 $Adress:"${ownclouddata}$2"
ssh ${Adress} "sudo chown -R www-data:www-data '${ownclouddata}$2'"
ssh ${Adress} "sudo chmod -R 750 '${ownclouddata}$2'"
ssh ${Adress} "sudo -u www-data php /var/www/owncloud/occ files:scan -v --path=$3"

