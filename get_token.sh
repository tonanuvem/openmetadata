#!/bin/bash

#!/bin/bash

# === CONFIGURAÇÕES ===
LOGIN="admin@open-metadata.org"              # Usuário (Login)
PASSWORD="admin"                              # Senha
AUTH_URL="http://localhost:8585/api/v1/auth/login" # URL para login do OpenMetadata
TOKEN_FILE="token.txt"                        # Caminho do arquivo para armazenar o token

# === GERAÇÃO DO TOKEN ===
RESPONSE=$(curl -s -X POST "$AUTH_URL" \
  -H "Content-Type: application/json" \
  -d '{"username": "'"$LOGIN"'", "password": "'"$PASSWORD"'"}')

# === EXTRAÇÃO DO TOKEN ===
ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.data.accessToken')

if [[ "$ACCESS_TOKEN" == "null" || -z "$ACCESS_TOKEN" ]]; then
  echo "❌ Falha ao obter token. Resposta do servidor:"
  echo "$RESPONSE"
  exit 1
fi

# === SALVANDO O TOKEN NO ARQUIVO ===
echo "$ACCESS_TOKEN" > "$TOKEN_FILE"

# === CONFIRMAÇÃO ===
echo "✅ Token obtido e salvo em '$TOKEN_FILE'"


###### VERIFICANDO
# Caminho do arquivo onde o token está salvo
TOKEN_FILE="token.txt"

# Verificar se o arquivo de token existe
if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "❌ Arquivo de token '$TOKEN_FILE' não encontrado. Execute o script de obtenção de token primeiro."
  exit 1
fi

# Ler o token do arquivo
ACCESS_TOKEN=$(cat "$TOKEN_FILE")

# Usar o token para fazer uma requisição à API
curl -X GET "http://localhost:8585/api/v1/users" -H "Authorization: Bearer $ACCESS_TOKEN"
