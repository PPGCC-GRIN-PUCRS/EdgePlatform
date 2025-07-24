#!/bin/bash
set -e
set -a
source .env
set +a

echo "🚀 Iniciando deploy..."

# Cria rede se não existir
docker network create proxy 2>/dev/null || true


cp docker-compose.yml docker-compose.yml.bak

echo "📄 Injetando variáveis em arquivos .yml..."

envsubst < docker-compose.yml > docker-compose.tmp.yml
mv docker-compose.tmp.yml docker-compose.yml

# Sobe os containers
echo "🐳 Subindo containers..."
docker-compose up -d

# Restaura arquivos com placeholders
echo "🧼 Restaurando arquivos originais com placeholders..."
mv docker-compose.yml.bak docker-compose.yml

echo "✅ Deploy finalizado com sucesso."