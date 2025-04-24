#curl -sL -o docker-compose.yml https://github.com/open-metadata/OpenMetadata/releases/download/1.7.0-release/docker-compose.yml

docker compose -f docker-compose.yml up --detach

echo ""
echo ""
echo "Config OK"
IP=$(curl -s checkip.amazonaws.com)
echo ""
echo "URLs do projeto:"
echo ""
echo " - OPEN METADATA        : http://$IP:8585   (login = admin@open-metadata.org, password = admin)"
echo ""
echo " - INGESTION (AIR FLOW) : http://$IP:8880   (login = admin@open-metadata.org, password = admin)"
