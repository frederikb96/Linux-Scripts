#!/bin/bash

status_exit=0;

check_status() {
	eval ${1}
	status=$?
	if [ $status -ne 0 ]; then status_exit=1; fi
	echo "Done and status: $status"
}

# Prepare
mkdir -p /databases

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
echo "Nextcloud DB:"
echo -e "--------------------\n"
source /opt/docker/nextcloud/.env
check_status "docker exec mariadb mysqldump --all-databases -p${MARIADB_MYSQL_ROOT_PASSWORD} > /databases/docker-nextcloud-mariadb.dump"
check_status "kopia snapshot create /databases/docker-nextcloud-mariadb.dump"
rm /databases/docker-nextcloud-mariadb.dump

echo -e "\n--------------------"
echo "Synapse DB:"
echo -e "--------------------\n"
check_status "docker exec postgres-synapse pg_dumpall -U synapse > /databases/docker-synapse-postgres.dump"
check_status "kopia snapshot create /databases/docker-synapse-postgres.dump"
rm /databases/docker-synapse-postgres.dump

echo -e "\n--------------------"
echo "Nextcloud:"
echo -e "--------------------\n"
check_status "kopia snapshot create /mnt/data/nextcloud"

echo -e "\n--------------------"
echo "Status:"
echo -e "--------------------\n"
kopia snapshot list -a

echo -e "\n--------------------"
echo "Overall:"
echo -e "--------------------\n"
echo $status_exit

if [ $status_exit -ne 0 ];
then echo "Backup failed for ubuntu-server" | sendmail fberg@posteo.de;
fi

exit $status_exit
