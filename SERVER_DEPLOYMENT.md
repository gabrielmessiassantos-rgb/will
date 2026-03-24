# 🖥️ Deploy em Qualquer Servidor

Guia completo para fazer deploy do WILL DTF Store em qualquer servidor Linux.

## 📋 Requisitos

- **Sistema Operacional**: Ubuntu 20.04+ / Debian 11+ (ou outro Linux)
- **Node.js**: 18.17.1+
- **npm/yarn**: Não precisa estar instalado (usamos o do Node.js)
- **Acesso SSH** ao servidor
- **2GB+ RAM** recomendado
- **10GB+ Espaço em disco** recomendado

---

## ⚡ Setup Rápido (Automático)

Se você tem um servidor Ubuntu/Debian, execute (no servidor):

```bash
curl -fsSL https://raw.githubusercontent.com/gabrielmessiassantos-rgb/will/main/scripts/setup-server.sh | bash
```

Este script automaticamente:
- ✅ Atualiza o sistema
- ✅ Instala Node.js 18
- ✅ Instala PM2 (gerenciador de processos)
- ✅ Instala Nginx (opcional)
- ✅ Instala Docker (opcional)
- ✅ Configura Firewall
- ✅ Cria estrutura de diretórios

---

## 🔧 Setup Manual (Passo a Passo)

### 1️⃣ Conectar ao Servidor

```bash
ssh seu-usuario@seu-servidor.com
```

### 2️⃣ Atualizar Sistema

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 3️⃣ Instalar Node.js 18

```bash
# Adicionar repositório Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Instalar Node.js
sudo apt-get install -y nodejs
```

### 4️⃣ Instalar PM2 (Gerenciador de Processos)

```bash
# Instalar globalmente
sudo npm install -g pm2

# Configurar para iniciar automaticamente no reboot
pm2 startup
pm2 save
```

### 5️⃣ Clonar Repositório

```bash
# Criar diretório da aplicação
mkdir -p ~/will-dtf
cd ~/will-dtf

# Clonar repositório
git clone https://github.com/gabrielmessiassantos-rgb/will.git .
```

### 6️⃣ Instalar Dependências

```bash
npm ci
```

### 7️⃣ Build

```bash
npm run build
```

### 8️⃣ Iniciar com PM2

```bash
# Iniciar aplicação
pm2 start ecosystem.config.js

# Salvar configuração (inicia automaticamente no reboot)
pm2 save

# Ver logs
pm2 logs will-dtf

# Ver status
pm2 status
```

---

## 🚀 Opção 1: PM2 (Recomendado)

### Iniciar Aplicação

```bash
cd ~/will-dtf
pm2 start ecosystem.config.js --name will-dtf
pm2 save
```

### Comandos Uteis

```bash
# Ver status
pm2 status

# Ver logs em tempo real
pm2 logs will-dtf

# Restart
pm2 restart will-dtf

# Stop
pm2 stop will-dtf

# Listar todos processos
pm2 list
```

### Arquivo de Configuração

O arquivo `ecosystem.config.js` já está configurado com:
- Modo cluster (usa todos os CPUs)
- Auto-restart em caso de erro
- Logging
- Health check

---

## 🐳 Opção 2: Docker + Docker Compose

### Instalação

```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Build e Run

```bash
cd ~/will-dtf

# Build da imagem
docker-compose build

# Iniciar container
docker-compose up -d

# Ver logs
docker-compose logs -f app

# Parar
docker-compose down
```

### Arquivos Necessários

- `Dockerfile` - Imagem da aplicação
- `docker-compose.yml` - Orquestração

---

## 🌐 Opção 3: Nginx + PM2

### Instalar Nginx

```bash
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Configurar Nginx como Proxy Reverso

```bash
# Criar configuração
sudo tee /etc/nginx/sites-available/will-dtf > /dev/null <<EOF
server {
    listen 80;
    server_name seu-dominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Ativar site
sudo ln -s /etc/nginx/sites-available/will-dtf /etc/nginx/sites-enabled/

# Remover site padrão
sudo rm -f /etc/nginx/sites-enabled/default

# Testar configuração
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
```

### HTTPS com Let's Encrypt

```bash
# Instalar Certbot
sudo apt-get install -y certbot python3-certbot-nginx

# Gerar certificado
sudo certbot --nginx -d seu-dominio.com

# Auto-renew está habilitado por padrão
```

---

## 📊 Monitoramento

### PM2 Monitoring

```bash
# Dashboard em tempo real
pm2 monit

# Web dashboard (porta 9615)
pm2 web
```

### Logs

```bash
# Ver logs da aplicação
pm2 logs will-dtf

# Logs do Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

---

## 🔄 Atualizar Aplicação

### Usando o Script de Deploy

```bash
./scripts/deploy.sh seu-usuario@seu-servidor.com main
```

### Manual

```bash
cd ~/will-dtf

# Atualizar código
git pull origin main

# Instalar dependências
npm ci

# Build
npm run build

# Restart
pm2 restart will-dtf
```

---

## 🔐 Segurança

### Firewall (UFW)

```bash
# Habilitar UFW
sudo ufw enable

# Abrir portas necessárias
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS

# Ver status
sudo ufw status
```

### Backup

```bash
# Criar backup do banco (se houver)
# Fazer backup de arquivos importantes
tar -czf ~/will-dtf-backup-$(date +%Y%m%d).tar.gz ~/will-dtf
```

---

## 🐛 Troubleshooting

### Porta 3000 em uso

```bash
# Encontrar processo usando a porta
lsof -i :3000

# Matar processo
kill -9 <PID>
```

### PM2 não inicia automaticamente

```bash
# Restaurar configuração PM2
pm2 unstartup
pm2 startup
pm2 save
```

### Build falha

```bash
# Limpar cache
rm -rf .next node_modules
npm ci
npm run build
```

### Sem conexão SSH

- Verificar IP do servidor
- Verificar porta SSH (padrão 22)
- Verificar firewall do servidor
- Gerar chaves SSH se necessário

---

## 📈 Performance

### Recomendações

1. **Node.js em cluster** (habilitado no ecosystem.config.js)
2. **Nginx como reverse proxy** (cache e compressão)
3. **PM2 com monitoramento** (auto-restart em caso de erro)
4. **Backup automático** (cronjob diário)

### Monitorar Recursos

```bash
# Ver uso de memória/CPU
top

# Ver espaço em disco
df -h

# Ver processos Node
ps aux | grep node
```

---

## 📞 Suporte

Se tiver problemas:

1. Verificar logs: `pm2 logs will-dtf`
2. Testar localmente: `npm run dev`
3. Verificar conectividade: `curl http://localhost:3000`
4. Abrir issue no GitHub

---

## ✅ Checklist de Deploy

- [ ] Servidor preparado (Node.js, PM2)
- [ ] Repositório clonado
- [ ] Dependências instaladas (`npm ci`)
- [ ] Build compilado (`npm run build`)
- [ ] PM2 iniciado (`pm2 start ecosystem.config.js`)
- [ ] PM2 salvo (`pm2 save`)
- [ ] Nginx configurado (opcional)
- [ ] HTTPS ativado (opcional)
- [ ] Firewall configurado
- [ ] Backups configurados
- [ ] Monitoramento ativo
- [ ] Testes de funcionalidade

---

**Pronto! Sua aplicação está rodando em produção! 🎉**

Para mais informações, ver [DEPLOYMENT.md](DEPLOYMENT.md)
