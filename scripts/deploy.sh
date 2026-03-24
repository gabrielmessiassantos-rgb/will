#!/bin/bash

# 📦 Deploy Script - WILL DTF Store
# Uso: ./scripts/deploy.sh [servidor] [branch]
# Exemplo: ./scripts/deploy.sh user@seu-servidor.com main

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configurações
SERVER="${1:-user@seu-servidor.com}"
BRANCH="${2:-main}"
REPO="gabrielmessiassantos-rgb/will"
APP_DIR="/home/deploy/will-dtf"

echo -e "${BLUE}🚀 Iniciando deploy do WILL DTF Store${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Servidor: ${SERVER}${NC}"
echo -e "${YELLOW}Branch: ${BRANCH}${NC}"
echo -e "${YELLOW}Diretório: ${APP_DIR}${NC}"
echo ""

# 1. Validar conexão com servidor
echo -e "${BLUE}1. Verificando conexão com servidor...${NC}"
if ! ssh -o ConnectTimeout=5 "$SERVER" "echo 'OK'" > /dev/null 2>&1; then
    echo -e "${RED}❌ Erro: Não foi possível conectar ao servidor${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Conectado ao servidor${NC}"

# 2. Clone/Pull do repositório
echo -e "\n${BLUE}2. Atualizando código do repositório...${NC}"
ssh "$SERVER" << 'EOF'
  if [ -d "APP_DIR" ]; then
    cd $APP_DIR
    git fetch origin
    git checkout $BRANCH
    git pull origin $BRANCH
  else
    mkdir -p $APP_DIR
    cd $APP_DIR
    git clone --branch $BRANCH https://github.com/$REPO.git .
  fi
EOF
echo -e "${GREEN}✅ Código atualizado${NC}"

# 3. Instalar dependências
echo -e "\n${BLUE}3. Instalando dependências...${NC}"
ssh "$SERVER" "cd $APP_DIR && npm ci" > /dev/null
echo -e "${GREEN}✅ Dependências instaladas${NC}"

# 4. Build
echo -e "\n${BLUE}4. Compilando aplicação...${NC}"
ssh "$SERVER" "cd $APP_DIR && npm run build" > /dev/null
echo -e "${GREEN}✅ Build concluído${NC}"

# 5. Restart da aplicação
echo -e "\n${BLUE}5. Reiniciando aplicação...${NC}"
ssh "$SERVER" "cd $APP_DIR && pm2 restart will-dtf || pm2 start ecosystem.config.js"
echo -e "${GREEN}✅ Aplicação reiniciada${NC}"

# 6. Verificar status
echo -e "\n${BLUE}6. Verificando status...${NC}"
ssh "$SERVER" "cd $APP_DIR && npm pm2 status"

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Deploy concluído com sucesso!${NC}"
echo -e "${BLUE}Aplicação rodando em: http://seu-servidor.com${NC}"
