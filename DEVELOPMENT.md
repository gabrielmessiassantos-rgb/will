# 🔧 Guia de Desenvolvimento

## Estrutura do Projeto

```
will/
├── app/
│   ├── api/              # Rotas da API (Next.js 13+ App Router)
│   ├── layout.tsx        # Layout root da aplicação
│   ├── page.tsx          # Página principal (Home)
│   └── globals.css       # Estilos globais com Tailwind
├── components/
│   └── ui/              # Componentes reutilizáveis (Card, Button, Input)
├── lib/
│   └── utils.ts         # Funções utilitárias
├── public/              # Assets estáticos
├── .env.example         # Variáveis de ambiente (exemplo)
├── .eslintrc.json       # Configuração ESLint
├── next.config.js       # Configuração Next.js
├── postcss.config.js    # Configuração PostCSS
├── tailwind.config.ts   # Configuração Tailwind CSS
├── tsconfig.json        # Configuração TypeScript
├── package.json         # Dependências do projeto
└── README.md           # Documentação principal
```

## 📝 Convenções de Código

### Componentes React
- Use `"use client"` no topo para componentes com interatividade
- Sempre prefira TypeScript
- Exporte tipos/interfaces usadas pelo componente

### Arquivos
- Use PascalCase para componentes React: `MyComponent.tsx`
- Use camelCase para funções/utilidades: `myUtility.ts`
- Use kebab-case para pastas: `my-folder`

### Estilos
- Use Tailwind CSS para estilos
- Evite CSS customizado quando possível
- Para componentes, use a função `cn()` do utils

## 🚀 Adicionando Novas Funcionalidades

### Exemplo: Adicionar um novo componente UI

1. Crie em `components/ui/novo-componente.tsx`
2. Exporte em um barrel export (opcional)
3. Importe em `app/page.tsx` ou onde necessário

### Exemplo: Adicionar uma rota de API

1. Crie `app/api/sua-rota/route.ts`
2. Use handlers: `export async function GET/POST/PUT/DELETE()`
3. Retorne `NextResponse`

## 🧪 Testes (Futuro)

```bash
npm run test
```

## 🐛 Debugging

Use o DevTools do Next.js:
- Painel de erro em desenvolvimento
- Source maps para TypeScript
- Editor de componentes React

## 📚 Recursos Úteis

- [Next.js Docs](https://nextjs.org/docs)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [ShadCN UI](https://ui.shadcn.com)
- [Framer Motion](https://www.framer.com/motion/)

## 💡 Dicas

1. **Hot Reload**: O Next.js atualiza automaticamente em desenvolvimento
2. **Type Safety**: Sempre use TypeScript para evitar erros
3. **Performance**: Use `Image` do Next.js em vez de `<img>`
4. **Animações**: Prefira Framer Motion para animações complexas

## 🚨 Troubleshooting

### Erro: "Module not found"
- Verifique o path alias em `tsconfig.json`
- Use `@/` para importar do root

### Erro: "Tailwind classes not applying"
- Recompile com `npm run build`
- Verifique se o arquivo está no `content` do `tailwind.config.ts`

### Porta 3000 já em uso
```bash
# Kill processo na porta 3000
lsof -i :3000
kill -9 <PID>

# Ou use outra porta
npm run dev -- -p 3001
```
