echo "Criando a configuração do Postgres"
curl -X POST https://localhost:8585/api/v1/services/databaseServices \
  -H "Content-Type: application/json" \
  -d @config_postgres.json
