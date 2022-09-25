#!/bin/bash

#--------------------
#Help
#--------------------

usage() {
echo "Get Help Message with: doowncloudtransfer.sh -h";
echo -e "\n--------------------"
echo "USE ONLY IF HARDLINK SUPPORT (NTFS and ext4)"
echo -e "--------------------\n"
echo "Source Path like: /home/freddy/Backup/owncloudbackup/";
echo "Destination path like: /media/freddy/SecondBackup/owncloudbackup/";
echo "Example to use: doowncloudtransfer.sh '/home/freddy/Backup/owncloudbackup/' '/media/freddy/SecondBackup/owncloudbackup/'";
exit 1; }

help=0

while getopts ":h" o; do
case "$o" in

h)
help=1
shift
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

if [ $# -ne 2 ]; then echo "Two Arguments needed!"; usage; fi




#--------------------
#Variables
#--------------------
adressSource="$1"
adressDestination="$2"

adressSourceSql="${adressSource}sql/"
adressDestinationSql="${adressDestination}sql/"

adressSourceConfig="${adressSource}config/"
adressDestinationConfig="${adressDestination}config/"

adressSourceData="${adressSource}data/"
adressDestinationData="${adressDestination}data/"

shadow=".rsyncShadowN"
shadowS=".rsyncShadow"

statusData=1
statusExit=0





echo -e "\n--------------------"
echo "USE ONLY IF HARDLINK SUPPORT (NTFS and ext4)"
echo -e "--------------------\n"






#--------------------
#Backup SQL
#--------------------
echo -e "\n--------------------"
echo "Backup SQL:"
echo -e "--------------------\n"

rsync -rthv ${adressSourceSql} ${adressDestinationSql}
if [ $? -ne 0 ]; then statusExit=1; fi


#--------------------
#Backup Config
#--------------------
echo -e "\n--------------------"
echo "Backup Config:"
echo -e "--------------------\n"

rsync -rthv ${adressSourceConfig} ${adressDestinationConfig}
if [ $? -ne 0 ]; then statusExit=1; fi

#--------------------
#Backup Data
#--------------------
echo -e "\n--------------------"
echo "Backup Data:"
echo -e "--------------------\n"

#Check if Shadow directory in source available
[ -d ${adressSourceData}${shadow} ]
if [ $? -eq 1 ] 
then
	#first time run: create source shadow
	echo "First time, create shadow:"
	rsync -rtvh --delete --link-dest=${adressSourceData} --exclude=$shadow --exclude=$shadowS ${adressSourceData} ${adressSourceData}${shadow}
	if [ $? -ne 0 ]; then statusExit=1; fi
	echo -e "Shadow created\n----------\n"
fi

#----
#Backup Main Part
#----
rsync -rtvhH --no-inc-recursive --delete --delete-after --exclude=$shadowS ${adressSourceData} ${adressDestinationData}

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
	rsync -rth --delete --link-dest=${adressSourceData} --exclude=$shadow --exclude=$shadowS ${adressSourceData} ${adressSourceData}${shadow}
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
    rsync -rth --delete --link-dest=${adressDestinationData} --exclude=$shadow --exclude=$shadowS ${adressDestinationData} ${adressDestinationData}${shadow}
    if [ $? -ne 0 ]; then statusExit=1; fi
else
    echo "Not updated, since sync had error!"
fi


#--------------------
#Result
#--------------------
echo -e "\n--------------------"
echo "Result:"
echo -e "--------------------\n"

echo "Main status exit is: $statusData"
echo "Overall status exit is: $statusExit"
exit $statusExit





