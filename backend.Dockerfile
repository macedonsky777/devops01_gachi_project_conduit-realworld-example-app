FROM node:18.20.4-alpine
WORKDIR /usr/src/app

# Встановлюємо PostgreSQL клієнт для health check
RUN apk add --no-cache postgresql-client

# Копіюємо package.json файли
COPY backend/package*.json ./
COPY package.json ./package.json
RUN npm install

# Копіюємо код бекенду
COPY backend/ .

# Копіюємо і налаштовуємо entrypoint скрипт
COPY backend/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3001
CMD ["/docker-entrypoint.sh", "npm", "run", "start"]
