#!/bin/bash
#--------------------
#Trap
#--------------------
adressInterrupted="/home/freddy/Desktop/backup_Interrupted.log"
trap "{ echo 'Terminated with SIGINT' >> ${adressInterrupted}; }" SIGINT
trap "{ echo 'Terminated with SIGTERM' >> ${adressInterrupted}; }" SIGTERM
trap "{ echo 'Terminated with SIGHUP' >> ${adressInterrupted}; }" SIGHUP


#--------------------
#Variables
#--------------------
day=`date +%d`
month=`date +%m`
year=`date +%Y`
hour=`date +%H`
min=`date +%M`


SECONDS=0
statusExit=0


adressBackup="/home/freddy/Computer/OwncloudBackupLog/"
adressError="/home/freddy/Desktop/"


maxExecutionTime=1


#--------------------
#Main
#--------------------


{ doowncloudbackup.sh; } > ${adressBackup}tmp.log 2>&1

if [ $? -ne 0 ]; then statusExit=1; fi

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
