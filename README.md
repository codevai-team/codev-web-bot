# Codev Project - Full Stack Application

Этот проект содержит два основных компонента:
1. **Codev Web App** - Next.js веб-приложение
2. **Codev Bot** - Telegram бот на Python

**Примечание**: База данных работает на внешнем сервере и не контейнеризирована.

## Быстрый запуск

### Предварительные требования
- Docker и Docker Compose
- Git
- Доступ к внешней базе данных PostgreSQL

### Настройка окружения

1. **Клонируйте репозиторий:**
```bash
git clone <repository-url>
cd codev-web-bot
```

2. **Настройте переменные окружения:**

Для веб-приложения:
```bash
cp codev/env.template codev/.env
# Отредактируйте codev/.env с вашими настройками
```

Для бота:
```bash
cp codev-bot.env.template codev-bot/.env
# Отредактируйте codev-bot/.env с настройками БД и Telegram токеном
```

3. **Запустите все сервисы:**
```bash
# Для продакшена
docker-compose up -d

# Для разработки
docker-compose -f docker-compose.dev.yml up -d
```

## Структура проекта

```
codev-web-bot/
├── codev/                 # Next.js веб-приложение
├── codev-bot/            # Python Telegram бот
├── docker-compose.yml    # Продакшен конфигурация
├── docker-compose.dev.yml # Разработка конфигурация
└── README.md
```

## Сервисы

### Веб-приложение (codev-web)
- **Порт:** 3000
- **Технологии:** Next.js, React, TypeScript
- **URL:** http://localhost:3000

### Telegram бот (codev-bot)
- **Технологии:** Python, aiogram, asyncpg
- **Подключение:** через Telegram API

### База данных
- **Тип:** Внешний PostgreSQL сервер
- **Настройка:** Через переменные окружения в .env файлах

## Команды Docker

```bash
# Запуск всех сервисов
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка всех сервисов
docker-compose down

# Пересборка контейнеров
docker-compose build --no-cache

# Очистка volumes (ВНИМАНИЕ: удалит данные БД)
docker-compose down -v
```

## Разработка

Для разработки используйте `docker-compose.dev.yml`:

```bash
# Запуск в режиме разработки
docker-compose -f docker-compose.dev.yml up -d

# Просмотр логов в режиме разработки
docker-compose -f docker-compose.dev.yml logs -f
```

В режиме разработки:
- Веб-приложение поддерживает hot reload
- Код бота автоматически перезапускается при изменениях
- Volumes настроены для синхронизации с локальными файлами

## Конфигурация

### Переменные окружения для веб-приложения (codev/.env)
```env
DATABASE_URL=postgresql://username:password@your_db_host:5432/your_db_name
# Другие переменные из codev/env.template
```

### Переменные окружения для бота (codev-bot/.env)
```env
BOT_TOKEN=your_telegram_bot_token_here
DB=postgresql://username:password@your_db_host:5432/your_db_name
IMGBB_API_KEY=your_imgbb_api_key_here
```

## Мониторинг и логи

```bash
# Логи всех сервисов
docker-compose logs -f

# Логи конкретного сервиса
docker-compose logs -f codev-web
docker-compose logs -f codev-bot
docker-compose logs -f postgres

# Статус сервисов
docker-compose ps
```

## Troubleshooting

### Проблемы с подключением к БД
- Убедитесь, что внешняя БД доступна из Docker контейнеров
- Проверьте правильность строки подключения в .env файлах
- Убедитесь, что фаервол не блокирует подключения

### Проблемы с сетью
```bash
# Пересоздание сети
docker-compose down
docker network prune
docker-compose up -d
```

### Очистка и пересборка
```bash
# Полная очистка и пересборка
docker-compose down -v
docker system prune -a
docker-compose build --no-cache
docker-compose up -d
```
