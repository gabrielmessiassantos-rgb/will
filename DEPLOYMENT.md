# 🚀 Guia de Deploy - WILL DTF Store

## ⚡ Opção 1: Deploy no Vercel (Recomendado)

Vercel é a plataforma oficial para Next.js com deploy contínuo automático.

### Passo a Passo:

1. **Ir para [vercel.com](https://vercel.com)**
2. **Conectar seu GitHub** (autorizar Vercel)
3. **Importar repositório**: `gabrielmessiassantos-rgb/will`
4. **Configurar variáveis de ambiente** (se necessário):
   - Deixar em branco inicialmente para demo
   - Adicionar `NEXT_PUBLIC_MERCADO_PAGO_PUBLIC_KEY` quando integrar pagamento
5. **Deploy automático** em `https://will-dtf.vercel.app`

### Recurso: Deploy automático em cada push

Após conectar, qualquer push em `main` fará deploy automático!

---

## 🐳 Opção 2: Docker

### Dockerfile:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package.json .
RUN npm ci

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

### Build e Run:

```bash
docker build -t will-dtf .
docker run -p 3000:3000 will-dtf
```

---

## 🔧 Opção 3: Netlify

1. Conectar GitHub em [netlify.com](https://netlify.com)
2. Selecionar repositório
3. Configurar:
   - Build command: `npm run build`
   - Publish directory: `.next`
4. Deploy automático

---

## 📋 Opção 4: Deploy Manual (Qualquer Servidor)

### Preparar para produção:

```bash
npm ci  # Instala exatas dependências
npm run build  # Compila
```

### Arquivos necessários em produção:

```
.next/
node_modules/
package.json
public/ (se houver)
```

### Iniciar servidor:

```bash
npm start
```

Aplicação rodará em: `http://localhost:3000`

---

## ✅ Checklist de Publicação

- [ ] Repositório público no GitHub
- [ ] `package-lock.json` removido do git
- [ ] `.env.example` documentado
- [ ] README.md atualizado
- [ ] Build funcionando localmente
- [ ] Sem erros de TypeScript/ESLint
- [ ] Plataforma de deploy escolhida
- [ ] Variáveis de ambiente configuradas
- [ ] Domain/URL definido
- [ ] HTTPS habilitado

---

## 🔐 Variáveis de Ambiente (Produção)

Nunca commitar `.env` - sempre usar secrets!

### Para Vercel:

1. Ir em Project Settings → Environment Variables
2. Adicionar vars seguras (ex: chaves de API)

### Para GitHub Actions:

1. Settings → Secrets and variables → Actions
2. Adicionar `VERCEL_TOKEN`, `VERCEL_ORG_ID`, etc.

---

## 📊 Monitoramento

### Vercel Analytics:
- Dashboard automático
- Performance metrics
- Error tracking

### Google Analytics (opcional):
```bash
npm install @vercel/analytics
```

Adicionar em `app/layout.tsx`:
```tsx
import { Analytics } from "@vercel/analytics/react";

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
```

---

## 🆘 Troubleshooting

### Build falha?
```bash
npm run build
# Ver mensagens de erro
```

### Erro de porta já em uso?
```bash
lsof -i :3000  # Achar processo
kill -9 <PID>  # Matar processo
```

### Não apareça variáveis de ambiente?
- Reiniciar deploy
- Verificar se nomes estão corretos
- Adicionar `NEXT_PUBLIC_` para públicas

---

## 🎯 Status de Deploy

Você pode visualizar:
- **GitHub**: https://github.com/gabrielmessiassantos-rgb/will
- **Deployment**: Após configurar (Vercel, Netlify, etc)

---

**Pronto para ir ao ar? Escolha uma opção acima e comece!** 🚀
