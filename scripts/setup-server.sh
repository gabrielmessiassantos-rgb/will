#!/bin/bash

# 🖥️  Setup Server Script - WILL DTF Store
# Execute este script uma única vez no servidor para preparar o ambiente
# Uso: curl -fsSL https://raw.githubusercontent.com/gabrielmessiassantos-rgb/will/main/scripts/setup-server.sh | bash

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🖥️  Setup Server - WILL DTF Store${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Verificar se é root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ Não execute como root. Use: sudo ./setup-server.sh${NC}"
   exit 1
fi

# 1. Atualizar sistema
echo -e "\n${BLUE}1. Atualizando sistema...${NC}"
sudo apt-get update -qq
sudo apt-get upgrade -y -qq > /dev/null
echo -e "${GREEN}✅ Sistema atualizado${NC}"

# 2. Instalar Node.js (se não estiver instalado)
echo -e "\n${BLUE}2. Verificando Node.js...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✅ Node.js já instalado: ${NODE_VERSION}${NC}"
else
    echo -e "${YELLOW}Installing Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null
    sudo apt-get install -y nodejs -qq > /dev/null
    echo -e "${GREEN}✅ Node.js instalado ($(node -v))${NC}"
fi

# 3. Instalar PM2 globalmente
echo -e "\n${BLUE}3. Instalando PM2...${NC}"
if npm list -g pm2 --depth 0 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ PM2 já instalado${NC}"
else
    sudo npm install -g pm2 -q
    echo -e "${GREEN}✅ PM2 instalado${NC}"
fi

# 4. Instalar Nginx (opcional)
echo -e "\n${BLUE}4. Instalando Nginx...${NC}"
if command -v nginx &> /dev/null; then
    echo -e "${GREEN}✅ Nginx já instalado${NC}"
else
    sudo apt-get install -y nginx -qq > /dev/null
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo -e "${GREEN}✅ Nginx instalado e iniciado${NC}"
fi

# 5. Instalar Docker (opcional)
echo -e "\n${BLUE}5. Verificando Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker já instalado ($(docker -v))${NC}"
else
    echo -e "${YELLOW}Instalando Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh -q
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo -e "${GREEN}✅ Docker instalado${NC}"
    echo -e "${YELLOW}⚠️  Você precisa fazer logout e login para aplicar as mudanças${NC}"
fi

# 6. Instalar Git
echo -e "\n${BLUE}6. Verificando Git...${NC}"
if command -v git &> /dev/null; then
    echo -e "${GREEN}✅ Git já instalado ($(git --version))${NC}"
else
    sudo apt-get install -y git -qq > /dev/null
    echo -e "${GREEN}✅ Git instalado${NC}"
fi

# 7. Criar estrutura de diretórios
echo -e "\n${BLUE}7. Criando estrutura de diretórios...${NC}"
mkdir -p ~/will-dtf/logs
mkdir -p ~/will-dtf/ssl
echo -e "${GREEN}✅ Diretórios criados em ~/will-dtf${NC}"

# 8. Configurar PM2 startup
echo -e "\n${BLUE}8. Configurando PM2 para iniciar automaticamente...${NC}"
pm2 startup -u $USER --no-save > /dev/null 2>&1 || true
echo -e "${GREEN}✅ PM2 configurado${NC}"

# 9. Configurar Firewall (se UFW está ativo)
echo -e "\n${BLUE}9. Verificando Firewall...${NC}"
if command -v ufw &> /dev/null && sudo ufw status | grep -q "Status: active"; then
    echo -e "${YELLOW}Abrindo portas no firewall...${NC}"
    sudo ufw allow 22/tcp > /dev/null 2>&1 || true
    sudo ufw allow 80/tcp > /dev/null 2>&1 || true
    sudo ufw allow 443/tcp > /dev/null 2>&1 || true
    echo -e "${GREEN}✅ Portas abertas (SSH, HTTP, HTTPS)${NC}"
else
    echo -e "${GREEN}✅ Firewall não ativo ou UFW não disponível${NC}"
fi

# 10. Criar usuário deploy (se não existir)
echo -e "\n${BLUE}10. Verificando usuário deploy...${NC}"
if id "deploy" &>/dev/null; then
    echo -e "${GREEN}✅ Usuário 'deploy' já existe${NC}"
else
    echo -e "${YELLOW}Criando usuário 'deploy'...${NC}"
    sudo useradd -m -s /bin/bash deploy || true
    echo -e "${GREEN}✅ Usuário 'deploy' criado${NC}"
fi

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Setup completo!${NC}"
echo -e "\n${BLUE}Próximos passos:${NC}"
echo -e "  1. Clone o repositório:"
echo -e "     ${YELLOW}git clone https://github.com/gabrielmessiassantos-rgb/will.git ~/will-dtf${NC}"
echo -e "  2. Entre no diretório:"
echo -e "     ${YELLOW}cd ~/will-dtf${NC}"
echo -e "  3. Instale dependências:"
echo -e "     ${YELLOW}npm ci${NC}"
echo -e "  4. Build:"
echo -e "     ${YELLOW}npm run build${NC}"
echo -e "  5. Inicie com PM2:"
echo -e "     ${YELLOW}pm2 start ecosystem.config.js${NC}"
echo -e "  6. Salve configuração PM2:"
echo -e "     ${YELLOW}pm2 save${NC}"
echo -e "\n${BLUE}Documentação:${NC}"
echo -e "  📖 ${YELLOW}./DEPLOYMENT.md${NC}"
echo -e "  📖 ${YELLOW}./DEVELOPMENT.md${NC}"
