# --- Estágio 1: Build ---
FROM node:20-alpine AS builder

WORKDIR /app

# Copia APENAS os arquivos de pacotes primeiro (garante o cache do Docker)
COPY package*.json ./

# Instala as dependências
RUN npm install

# --- Estágio 2: Final ---
FROM node:20-alpine

WORKDIR /app

# Copia as dependências do estágio 'builder'
COPY --from=builder /app/node_modules ./node_modules

# Copia o restante do código-fonte
COPY . .

# Expõe a porta exigida
EXPOSE 3000

# Cria a pasta e passa a propriedade dela para o usuário 'node'
RUN mkdir -p /etc/todos && chown -R node:node /etc/todos

# Define um usuário não-root (a imagem node já possui o usuário 'node' por padrão)
USER node

# Comando padrão para rodar a aplicação (ajuste se o seu script for outro)
CMD ["npm", "start"]