# Conduit RealWorld Example App

Full stack блог-платформа, що реалізує специфікацію [RealWorld](https://github.com/gothinkster/realworld).

## Технології

### Backend
- Node.js + Express - серверна частина
- Sequelize - ORM для роботи з базою даних
- PostgreSQL - база даних
- JWT - автентифікація
- bcrypt - хешування паролів

### Frontend
- React - UI бібліотека
- Vite - збірка та dev-сервер
- React Router - маршрутизація
- Axios - HTTP клієнт

## Структура проекту
```
.
├── backend/                # Серверна частина
│   ├── config/            # Конфігурація бази даних
│   ├── controllers/       # Контролери API
│   ├── models/           # Моделі даних
│   ├── routes/           # API маршрути
│   └── docker-entrypoint.sh
├── frontend/              # Клієнтська частина
│   ├── src/
│   │   ├── components/   # React компоненти
│   │   ├── context/      # React контексти
│   │   ├── routes/       # Компоненти сторінок
│   │   └── services/     # API сервіси
│   └── nginx.conf
├── backend.Dockerfile
├── frontend.Dockerfile
├── docker-compose.yml      # Конфігурація для розробки
└── docker-compose.prod.yml # Продакшен конфігурація
```

## Конфігурація проекту

### Frontend (Vite)
Для правильної роботи з Docker та проксування API запитів, переконайтеся що ваш `vite.config.js` містить наступні налаштування:

```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',    // Дозволяє доступ ззовні контейнера
    port: 3000,         // Порт для фронтенд серверу
    watch: {
      usePolling: true  // Необхідно для правильної роботи hot-reload в Docker
    },
    proxy: {
      '/api': {
        target: process.env.VITE_API_URL || 'http://backend:3001', // URL бекенду
        changeOrigin: true
      }
    }
  }
})
```

Важливі налаштування:
- `host: '0.0.0.0'` - необхідно для доступу до dev-сервера з Docker контейнера
- `usePolling: true` - забезпечує коректну роботу file watching в Docker
- Проксі налаштування для API запитів:
  - В розробці використовує `http://backend:3001` (DNS ім'я з docker-compose)
  - В продакшені використовує значення з `VITE_API_URL`


## Запуск проекту

### Змінні середовища
Створіть `.env` файл у корені проекту:

```env
# Для розробки
DEV_DB_USERNAME=root
DEV_DB_PASSWORD=root
DEV_DB_NAME=database_development
DEV_DB_HOSTNAME=db
DEV_DB_DIALECT=postgres
DEV_DB_LOGGING=1
JWT_KEY=your_jwt_secret_key

# Для продакшену
PROD_DB_USERNAME=prod_user
PROD_DB_PASSWORD=secure_password
PROD_DB_NAME=database_production
PROD_DB_HOSTNAME=db
PROD_DB_DIALECT=postgres
PROD_DB_LOGGING=0
JWT_KEY=your_production_jwt_secret
```

### Локальна розробка
1. Встановіть Docker та Docker Compose
2. Запустіть проект:
```bash
docker-compose up
```
- Frontend буде доступний на http://localhost:3000
- Backend API на http://localhost:3001
- База даних на localhost:5432

### Продакшен розгортання
1. Налаштуйте змінні середовища для продакшену
2. Запустіть використовуючи продакшен конфігурацію:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Окреме розгортання сервісів

#### База даних:
```bash
docker-compose -f docker-compose.prod.yml up db
```

#### Backend:
```bash
# Потрібно налаштувати DB_HOSTNAME у змінних середовища
docker-compose -f docker-compose.prod.yml up backend
```

#### Frontend:
```bash
# Потрібно налаштувати VITE_API_URL для з'єднання з backend
docker-compose -f docker-compose.prod.yml up frontend
```

## Архітектура

### Backend
- RESTful API на Express.js
- Sequelize ORM для роботи з PostgreSQL
- JWT автентифікація
- Модульна структура (controllers/models/routes)

### Frontend
- SPA на React з React Router
- Контексти для управління станом (Auth, Feed)
- Сервіси для API запитів
- Компонентна архітектура

### Взаємодія
- Frontend -> Backend через REST API
- Backend -> PostgreSQL через Sequelize
- Автентифікація через JWT токени
- Nginx як проксі для фронтенду

## Ліцензія
MIT License
