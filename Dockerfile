# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar package files
COPY package.json ./

# Instalar dependências (usando npm ci para produção)
RUN npm ci

# Copiar código
COPY . .

# Build
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Instalar apenas dependências de produção
COPY package.json ./
RUN npm ci --only=production

# Copiar arquivos compilados do builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Criar usuário não-root por segurança
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

EXPOSE 3000

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

CMD ["node_modules/.bin/next", "start"]
