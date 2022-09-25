#!/bin/bash

#--------------------
#Data
#--------------------
#Pi Adresses
adressPi="pi@192.168.0.129"
adressPiOwncloudOcc="/var/www/owncloud/occ"

error=0


#--------------------
#Functions
#--------------------
usage() {
echo "Example to use: doowncloudmaintenance.sh on";
echo "Get Help Message with: doowncloudmaintenance.sh -h";
exit 1; }


#--------------------
#Syntax
#--------------------

while getopts ":h" o; do
case "$o" in

h)
error=1
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

if [ $# -ne 1 ]
then
echo "One Agrument necessary!"
error=1
fi

if [ $error -eq 1 ]
then
usage
fi

#--------------------
#Main
#--------------------
if [ "$1" = "on" ]
then
echo "Mode On:"
ssh ${adressPi} "sudo -u www-data php $adressPiOwncloudOcc maintenance:mode --on -v"
elif [ "$1" = "off" ]
then
echo "Mode Off:"
ssh ${adressPi} "sudo -u www-data php $adressPiOwncloudOcc maintenance:mode --off -v"
else
echo "No valid Argument!"
usage
fi



