# Docker Setup для CodevApp

Этот документ содержит инструкции по контейнеризации и запуску проекта CodevApp с помощью Docker.

## 📋 Структура Docker файлов

- `Dockerfile` - Продакшн образ с оптимизацией размера
- `Dockerfile.dev` - Образ для разработки с hot reload
- `docker-compose.yml` - Конфигурация для продакшн развертывания
- `docker-compose.dev.yml` - Конфигурация для разработки
- `.dockerignore` - Исключения для Docker build

## 🚀 Быстрый старт

### Разработка

```bash
# Сборка и запуск для разработки
docker-compose -f docker-compose.dev.yml up --build

# Или в фоновом режиме
docker-compose -f docker-compose.dev.yml up -d --build
```

Приложение будет доступно по адресу: http://localhost:3000

### Продакшн

```bash
# Сборка и запуск продакшн версии
docker-compose up --build

# Или в фоновом режиме
docker-compose up -d --build
```

## 🛠️ Отдельные команды Docker

### Сборка образов

```bash
# Продакшн образ
docker build -t codev-app .

# Образ для разработки
docker build -f Dockerfile.dev -t codev-app-dev .
```

### Запуск контейнеров

```bash
# Продакшн
docker run -p 3000:3000 codev-app

# Разработка с монтированием папки
docker run -p 3000:3000 -v $(pwd):/app -v /app/node_modules codev-app-dev
```

## 🔧 Переменные окружения

Создайте файл `.env` в корне проекта:

```env
# База данных PostgreSQL
DATABASE_URL=postgresql://username:password@localhost:5432/database_name

# API ключи  
NEXT_PUBLIC_API_URL=http://localhost:3000/api

# Другие переменные
NEXT_TELEMETRY_DISABLED=1

# Добавьте здесь другие переменные
# API_KEY=your_api_key
# TELEGRAM_BOT_TOKEN=your_telegram_bot_token
```

Docker Compose автоматически загружает переменные из файла `.env` благодаря секции `env_file`.

### Приоритет переменных окружения:
1. Переменные из секции `environment` в docker-compose.yml (высший приоритет)
2. Переменные из файла `.env` 
3. Переменные окружения системы

## 📦 Особенности конфигурации

### Puppeteer Support

Образы настроены для работы с Puppeteer:
- Включен Chromium браузер
- Настроены необходимые зависимости
- Установлена переменная `PUPPETEER_EXECUTABLE_PATH`
- Использует npm для управления зависимостями (совместимо с package-lock.json)

### Next.js Optimization

- Используется `output: 'standalone'` для минимального размера
- Многоэтапная сборка для оптимизации
- Отдельный пользователь `nextjs` для безопасности

## 🗄️ База данных (PostgreSQL)

Раскомментируйте секцию PostgreSQL в `docker-compose.yml` если нужна база данных:

```yaml
postgres:
  image: postgres:15-alpine
  environment:
    POSTGRES_DB: codev
    POSTGRES_USER: postgres
    POSTGRES_PASSWORD: password
  volumes:
    - postgres_data:/var/lib/postgresql/data
  ports:
    - "5432:5432"
```

## 🌐 Nginx (обратный прокси)

Для продакшн развертывания рекомендуется использовать Nginx:

1. Раскомментируйте секцию Nginx в `docker-compose.yml`
2. Создайте конфигурацию `nginx.conf`
3. Настройте SSL сертификаты в папке `ssl/`

## 📋 Полезные команды

```bash
# Просмотр логов
docker-compose logs -f

# Остановка контейнеров
docker-compose down

# Пересборка без кэша
docker-compose build --no-cache

# Очистка неиспользуемых образов
docker system prune -a

# Вход в контейнер
docker-compose exec app sh

# Просмотр запущенных контейнеров
docker-compose ps
```

## 🔍 Отладка

### Проблемы с Puppeteer

Если возникают проблемы с Puppeteer:

```bash
# Проверить доступность Chromium в контейнере
docker-compose exec app chromium-browser --version

# Проверить переменные окружения
docker-compose exec app env | grep PUPPETEER
```

### Проблемы с сетевым подключением

Если контейнер не может подключиться к внешним API:

```bash
# Проверить DNS настройки
docker-compose exec app nslookup google.com

# Проверить подключение к OpenAI API
docker-compose exec app ping api.openai.com

# Проверить переменные окружения API
docker-compose exec app env | grep API
```

**Решения сетевых проблем:**
- Убедитесь, что файл `.env` содержит все необходимые API ключи
- Проверьте настройки брандмауэра и антивируса
- Попробуйте запустить контейнер с `--network=host` для тестирования

### Проблемы с сборкой

```bash
# Очистить Docker кэш
docker builder prune -a

# Пересобрать с чистого листа
docker-compose down
docker-compose build --no-cache
docker-compose up
```

## 📈 Производительность

### Оптимизация размера образа

Текущий Dockerfile оптимизирован:
- Использует Alpine Linux
- Многоэтапная сборка
- Минимальные зависимости
- Standalone режим Next.js

### Мониторинг ресурсов

```bash
# Статистика использования ресурсов
docker stats

# Размер образов
docker images
```

## 🚀 Развертывание

### Локальное развертывание

```bash
git clone <your-repo>
cd codev
docker-compose up -d --build
```

### Облачное развертывание

1. **Docker Hub / GitHub Container Registry**
   ```bash
   docker build -t your-username/codev-app .
   docker push your-username/codev-app
   ```

2. **Digital Ocean / AWS / GCP**
   - Используйте docker-compose.yml
   - Настройте переменные окружения
   - Настройте обратный прокси и SSL

## 🔐 Безопасность

- Контейнер запускается от непривилегированного пользователя
- Переменные окружения изолированы
- Используются официальные базовые образы
- Минимальная атакующая поверхность (Alpine Linux)

## 📞 Поддержка

Если у вас возникли проблемы с Docker конфигурацией:

1. Проверьте логи: `docker-compose logs -f`
2. Убедитесь, что Docker и docker-compose установлены
3. Проверьте доступность портов 3000 и 5432
4. Убедитесь в наличии достаточного места на диске

---

**Примечание**: Убедитесь, что у вас установлены Docker и Docker Compose последних версий для корректной работы всех функций.
