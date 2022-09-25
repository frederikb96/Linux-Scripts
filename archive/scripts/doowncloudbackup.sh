#!/bin/bash

#--------------------
#Trap
#--------------------
adressInterrupted="/home/freddy/Desktop/backup_InterruptedInternal.log"
trap "{ echo 'Terminated with SIGINT' >> ${adressInterrupted}; }" SIGINT
trap "{ echo 'Terminated with SIGTERM' >> ${adressInterrupted}; }" SIGTERM
trap "{ echo 'Terminated with SIGHUP' >> ${adressInterrupted}; }" SIGHUP

#--------------------
#Data
#--------------------
#Pi Adresses
adressPi="pi@192.168.0.129"
adressPiOwncloudConfig="/var/www/owncloud/config/"
adressPiOwncloudData="/mnt/owncloud/ownclouddata/"


#SQL
sqlUser="ownclouduser"
sqlPassword=""
sqlDatabase="owncloud"
adressPiSqlBackup="/home/pi/tmp/owncloudSqlBackup.bak"
adressPiSqlBackupTake=$adressPiSqlBackup

#Freddy Adresses
adressFreddyOwncloud="/home/freddy/Backup/owncloudbackup/"
adressFreddySqlBackup="${adressFreddyOwncloud}sql/"
adressFreddyOwncloudConfig="${adressFreddyOwncloud}config/"
adressFreddyOwncloudData="${adressFreddyOwncloud}data/"


#Test
#adressPiOwncloudConfig="/mnt/owncloud/test/config/"
#adressPiOwncloudData="/mnt/owncloud/test/data/"
#adressPiSqlBackupTake="/mnt/owncloud/test/sql/owncloudSqlBackup.bak"
#adressFreddySqlBackup="/mnt/Backup/owncloudbackup/test/sql/"
#adressFreddyOwncloudConfig="/mnt/Backup/owncloudbackup/test/config/"
#adressFreddyOwncloudData="/mnt/Backup/owncloudbackup/test/data/"

#Shadow
shadow=".rsyncShadow"
shadowS=".rsyncShadowN"

#--------------------
#Variables
#--------------------
error=0
statusData=1
statusExit=0


#--------------------
#Functions
#--------------------
usage() {
echo "Example to use: doowncloudbackup.sh";
echo "Get Help Message with: doowncloudbackup.sh -h";
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
#Backup SQL
#--------------------
echo -e "\n--------------------"
echo "Backup SQL:"
echo -e "--------------------\n"

ssh ${adressPi} "sudo mysqldump --single-transaction -h localhost -u $sqlUser -p$sqlPassword $sqlDatabase > $adressPiSqlBackup"
if [ $? -ne 0 ]; then statusExit=1; fi

rsync -thv --rsync-path="sudo rsync" ${adressPi}:$adressPiSqlBackupTake $adressFreddySqlBackup
if [ $? -ne 0 ]; then statusExit=1; fi

#--------------------
#Enable Maintenance
#--------------------
#echo -e "\n--------------------"
#echo "Enable Maintenance:"
#echo -e "--------------------\n"
#/home/freddy/.local/bin/doowncloudmaintenance.sh on
#if [ $? -ne 0 ]; then statusExit=1; fi

#--------------------
#Backup Config
#--------------------
echo -e "\n--------------------"
echo "Backup Config:"
echo -e "--------------------\n"

rsync -rthv --rsync-path="sudo rsync" ${adressPi}:$adressPiOwncloudConfig $adressFreddyOwncloudConfig
if [ $? -ne 0 ]; then statusExit=1; fi


#--------------------
#Backup Data
#--------------------
echo -e "\n--------------------"
echo "Backup Data:"
echo -e "--------------------\n"


#Check if Shadow directory in source available
ssh $adressPi "sudo [ -d ${adressPiOwncloudData}${shadow} ]"
if [ $? -eq 1 ] 
then
	#first time run: create source shadow
	echo "First time, create shadow:"
	ssh $adressPi "sudo rsync -rtvh --delete --link-dest=$adressPiOwncloudData --exclude=$shadow --exclude=$shadowS $adressPiOwncloudData ${adressPiOwncloudData}${shadow}"
	if [ $? -ne 0 ]; then statusExit=1; fi
	echo -e "Shadow created\n----------\n"
fi

#----
#Backup Main Part
#----
rsync -rtvhH --rsync-path="sudo rsync" --no-inc-recursive --delete --delete-after --exclude=$shadowS ${adressPi}:$adressPiOwncloudData $adressFreddyOwncloudData

statusData=$?
if [ $statusData -ne 0 ]; then statusExit=1; fi


#--------------------
#Update Shadow Source
#--------------------
echo -e "\n--------------------"
echo "Update Shadow Source:"
echo -e "--------------------\n"

if [ $statusData -eq 0 ]
then
	ssh $adressPi "sudo rsync -rth --delete --link-dest=$adressPiOwncloudData --exclude=$shadow --exclude=$shadowS $adressPiOwncloudData ${adressPiOwncloudData}${shadow}"
	if [ $? -ne 0 ]; then statusExit=1; fi
else
    echo "Not updated, since sync had error!"
fi

#--------------------
#Update Shadow Destination
#--------------------
echo -e "\n--------------------"
echo "Update Shadow Destination:"
echo -e "--------------------\n"

if [ $statusData -eq 0 ]
then
    rsync -rth --delete --link-dest=$adressFreddyOwncloudData --exclude=$shadow --exclude=$shadowS $adressFreddyOwncloudData ${adressFreddyOwncloudData}${shadow}
    if [ $? -ne 0 ]; then statusExit=1; fi
else
    echo "Not updated, since sync had error!"
fi

#--------------------
#Disable Maintenance
#--------------------
#echo -e "\n--------------------"
#echo "Disable Maintenance:"
#echo -e "--------------------\n"
#doowncloudmaintenance.sh off
#if [ $? -ne 0 ]; then statusExit=1; fi

#--------------------
#Result
#--------------------
echo -e "\n--------------------"
echo "Result:"
echo -e "--------------------\n"

echo "Main status exit is: $statusData"
echo "Overall status exit is: $statusExit"
exit $statusExit
