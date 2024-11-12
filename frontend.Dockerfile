FROM node:18.20.4-alpine as builder
WORKDIR /usr/src/app

# Копіюємо package.json файли
COPY frontend/package*.json ./
COPY package.json ./package.json
RUN npm install

# Копіюємо код фронтенду
COPY frontend/ .

# Білд проекту
RUN npm run build

# Налаштовуємо nginx
FROM nginx:alpine
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
