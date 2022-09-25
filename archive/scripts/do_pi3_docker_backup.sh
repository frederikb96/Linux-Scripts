#!/bin/bash

#--------------------
#Data
#--------------------
#Pi Adresses
adressPi="root@192.168.0.101"
adressPiBackup="/opt/docker/backup/"
adressPiComposeFile="/opt/docker/apps/docker-compose.yml"
namePiBackupScript="docker_backup_all.sh"

#Freddy Adresses
adressFreddyBackup="/home/freddy/Backup/pi3/docker/"


#--------------------
#Variables
#--------------------
error=0
statusExit=0


#--------------------
#Functions
#--------------------
usage() {
echo "Example to use: do_pi3_docker_backup.sh";
echo "Get Help Message with: do_pi3_docker_backup.sh -h";
exit 1; }


#--------------------
#Syntax
#--------------------

while getopts ":h" o; do
case "$o" in

h)
error=1
shift
;;

:)
echo "No Argument is allowed!"
error=1
;;

?)
echo "Invalid Option -${OPTARG}"
error=1
;;

esac
done

if [ $# -ne 0 ]
then
echo "No Argument is allowed!"
error=1
fi

if [ $error -eq 1 ]
then
usage
fi

#--------------------
#Backup Docker
#--------------------
echo -e "\n--------------------"
echo "Backup Docker:"
echo -e "--------------------\n"

ssh root@pi3.lan 'tar cf - /opt/docker' > /home/freddy/Backup/pi3/docker.tar

#--------------------
#Result
#--------------------
echo -e "\n--------------------"
echo "Result:"
echo -e "--------------------\n"

echo "Overall status exit is: $statusExit"
exit $statusExit
