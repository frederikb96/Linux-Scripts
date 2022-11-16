#!/bin/bash

# Docker update function
docker_update() {
echo ""
echo "###"
echo "Start docker update"
echo "###"
docker compose pull
docker compose up -d
sleep 5
docker compose logs -t --since 168h | grep -i err | grep -v -e "PHP_ERROR_LOG" -e "OCSP stapling"

}

# Main

# Docker
cd /opt/docker/info
docker_update
cd /opt/docker/dns
docker_update
cd /opt/docker/caddy
docker_update

echo ""
echo "###"
echo "Docker Prune"
echo "###"
docker image prune -f

# APT
echo ""
echo "###"
echo "APT"
echo "###"
apt update && apt upgrade && apt autoremove
