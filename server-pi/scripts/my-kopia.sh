#!/bin/bash
kopia repository connect sftp --path=/mnt/backup/backup-server --host=ubuntu-server.lan --username=root --keyfile=/root/.ssh/id_rsa --known-hosts=/root/.ssh/known_hosts
