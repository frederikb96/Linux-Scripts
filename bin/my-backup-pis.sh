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
ssh root@pi3.lan kopia snapshot create /opt/docker
statusUnison=$?
if [ $statusUnison -ne 0 ]; then statusExit=1; fi
echo "done"
echo "$statusUnison"

echo -e "\n--------------------"
echo "Pi4 Docker:"
echo -e "--------------------\n"
ssh root@pi4.lan kopia snapshot create /opt/docker
statusUnison=$?
if [ $statusUnison -ne 0 ]; then statusExit=1; fi
echo "done"
echo "$statusUnison"

echo -e "\n--------------------"
echo "Pi4 Nextcloud DB:"
echo -e "--------------------\n"
ssh root@pi4.lan 'source /opt/docker/nextcloud/.env && docker exec mariadb mysqldump --all-databases -p${MARIADB_MYSQL_ROOT_PASSWORD} > /databases/docker-nextcloud-mariadb.dump && kopia snapshot create /databases/docker-nextcloud-mariadb.dump && rm /databases/docker-nextcloud-mariadb.dump'
statusUnison=$?
if [ $statusUnison -ne 0 ]; then statusExit=1; fi
echo "done"
echo "$statusUnison"

echo -e "\n--------------------"
echo "Pi4 Synapse DB:"
echo -e "--------------------\n"
ssh root@pi4.lan 'docker exec postgres-synapse pg_dumpall -U synapse > /databases/docker-synapse-postgres.dump && kopia snapshot create /databases/docker-synapse-postgres.dump && rm /databases/docker-synapse-postgres.dump'
statusUnison=$?
if [ $statusUnison -ne 0 ]; then statusExit=1; fi
echo "done"
echo "$statusUnison"

echo -e "\n--------------------"
echo "Pi4 Nextcloud:"
echo -e "--------------------\n"
ssh root@pi4.lan kopia snapshot create /mnt/data/nextcloud
statusUnison=$?
if [ $statusUnison -ne 0 ]; then statusExit=1; fi
echo "done"
echo "$statusUnison"

echo -e "\n--------------------"
echo "Pi3 Status:"
echo -e "--------------------\n"
ssh root@pi3.lan kopia snapshot list

echo -e "\n--------------------"
echo "Pi4 Status:"
echo -e "--------------------\n"
ssh root@pi4.lan kopia snapshot list

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
