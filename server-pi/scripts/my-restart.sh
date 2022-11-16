#!/bin/bash

# Docker update function
docker_restart() {
echo ""
echo "###"
echo "Start docker restart"
echo "###"
docker compose down
docker compose up -d
sleep 1

}

# Main

# Docker
cd /opt/docker/info
docker_restart
cd /opt/docker/dns
docker_restart
cd /opt/docker/caddy
docker_restart
