curl -sL -o docker-compose.yml https://github.com/open-metadata/OpenMetadata/releases/download/1.7.0-release/docker-compose.yml
sed -i '/^\s*version:/ s/^/#/' docker-compose.yml
sed -i 's/3306:3306/3366:3306/' docker-compose.yml
sed -i 's/AUTHENTICATION_PROVIDER: .*/AUTHENTICATION_PROVIDER: "no-auth"/' docker-compose.yaml


docker-compose -f docker-compose.yml up --detach

AIRFLOW_msglog="INFO - Starting the scheduler"
OPENMETADATA_msglog="Started application"

echo ""
echo "Aguardando a configuração do OPEN METADATA."
while [ "$(docker logs openmetadata_ingestion 2>&1 | grep "$AIRFLOW_msglog" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done
while [ "$(docker logs openmetadata_server 2>&1 | grep "$OPENMETADATA_msglog" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done

echo ""
echo ""
echo "Config OK"
IP=$(curl -s checkip.amazonaws.com)
echo ""
echo "URLs do projeto:"
echo ""
echo " - OPEN METADATA        : http://$IP:8585   (login = admin@open-metadata.org, password = admin)"
echo ""
echo " - INGESTION (AIR FLOW) : http://$IP:8080   (login = admin, password = admin)"
echo ""
echo ""
