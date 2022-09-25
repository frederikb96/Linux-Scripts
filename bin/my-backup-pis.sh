#!/bin/bash

#--------------------
# Variables
#--------------------
day=`date +%d`
month=`date +%m`
year=`date +%Y`
hour=`date +%H`
min=`date +%M`

SECONDS=0
maxExecutionTime=10
statusExit=0

adressBackup="/home/freddy/Nextcloud/Computer/Pi_Backup_Log/"
adressError="/home/freddy/Desktop/"


#--------------------
# Main
#--------------------

{
echo -e "\n--------------------"
echo "Pi3 Docker:"
echo -e "--------------------\n"
ssh root@pi3.lan 'tar cvf - /opt/docker' > /home/freddy/Backup/pi3/docker.tar
if [ $? -ne 0 ]; then statusExit=1; fi
echo "done"

echo -e "\n--------------------"
echo "Pi4 Docker:"
echo -e "--------------------\n"
ssh root@pi4.lan 'tar cvf - /opt/docker' > /home/freddy/Backup/pi4/docker.tar
if [ $? -ne 0 ]; then statusExit=1; fi
echo "done"

echo -e "\n--------------------"
echo "Pi4 Nextcloud:"
echo -e "--------------------\n"
unison my-profiles/pi-nextcloud > /dev/null
if [ $? -ne 0 ]; then statusExit=1; fi
echo "done"
} >> ${adressBackup}tmp.log 2>&1


#--------------------
# Log Processing
#--------------------

ElM=$((SECONDS / 60))

name="backup_${year}_${month}_${day}_${hour}h_${min}m_ElM$ElM"

find ${adressBackup}* -mtime +30 -type f -name "backup_*" -exec rm {} \;

mv -f ${adressBackup}tmp.log ${adressBackup}$name.log

if [ $statusExit -ne 0 ]
then
    mv -f ${adressBackup}$name.log ${adressBackup}${name}_ERROR.log
    cp ${adressBackup}${name}_ERROR.log ${adressError}
elif [ $ElM -gt $maxExecutionTime ]; then
    mv -f ${adressBackup}$name.log ${adressBackup}${name}_TIME.log
    cp ${adressBackup}${name}_TIME.log ${adressError}
fi

exit $statusExit
