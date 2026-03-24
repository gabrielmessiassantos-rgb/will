#!/bin/bash

# WILL DTF - Script de Inicialização Rápida

echo "🚀 WILL DTF - Iniciando servidor de desenvolvimento..."
echo ""
echo "📋 Informações:"
echo "  • Projeto: WILL DTF Store"
echo "  • Framework: Next.js 14"
echo "  • Estilização: Tailwind CSS"
echo "  • Animações: Framer Motion"
echo "  • Porta: 3000"
echo ""
echo "🔗 Acesse em: http://localhost:3000"
echo ""

cd "$(dirname "$0")"
npm run dev
