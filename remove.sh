#!/bin/bash

docker-compose stop && docker-compose rm -f && docker volume prune -f && git pull
echo ""
echo "Removendo volumes:"
# Lista todos os volumes e remove cada um
docker volume ls -q | grep openmetadata | while read volume; do
  #echo "Removendo volume: $volume"
  docker volume rm "$volume"
done
echo ""
