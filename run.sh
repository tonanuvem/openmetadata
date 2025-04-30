#!/bin/bash

set -euo pipefail

OM_VERSION="1.7.0-release"
OM_COMPOSE_URL="https://github.com/open-metadata/OpenMetadata/releases/download/${OM_VERSION}/docker-compose.yml"
OM_COMPOSE_FILE="docker-compose.yml"

echo "🔽 Baixando docker-compose do OpenMetadata ${OM_VERSION}..."
curl -sL -o "${OM_COMPOSE_FILE}" "${OM_COMPOSE_URL}"

echo "🔧 Comentando linha 'version:' para compatibilidade..."
sed -i '/^\s*version:/ s/^/#/' "${OM_COMPOSE_FILE}"

echo "🔧 Alterando porta do MySQL para evitar conflito local (3306 → 3366)..."
sed -i 's/3306:3306/3366:3306/' "${OM_COMPOSE_FILE}"

echo "🔧 Definindo AUTHENTICATION_PROVIDER como 'no-auth'..."
sed -i 's/AUTHENTICATION_PROVIDER: .*/AUTHENTICATION_PROVIDER: "no-auth"/' "${OM_COMPOSE_FILE}"

echo "🧹 Comentando variáveis relacionadas a autenticação externa (OIDC, Auth0, etc)..."
sed -i '/^[[:space:]]*\(OIDC_\|AUTH0_\|AZURE_\|OKTA_\|GOOGLE_\|GITHUB_\)/s/^\([[:space:]]*\)/\1# /' "${OM_COMPOSE_FILE}"

echo "✅ docker-compose.yml configurado com sucesso para 'no-auth'."


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
echo " - OPEN METADATA        : http://$IP:8585"
#echo " - OPEN METADATA        : http://$IP:8585   (login = admin@open-metadata.org, password = admin)"
echo ""
echo " - INGESTION (AIR FLOW) : http://$IP:8080   (login = admin, password = admin)"
echo ""
echo ""
