# 🚀 Руководство по деплою

## Проблема решена! ✅

Теперь в корне проекта есть `Dockerfile`, который система деплоя найдет автоматически.

## 📦 Что создано:

### 1. **Dockerfile** (корневой) 
- Деплой веб-приложения (Next.js)
- Оптимизированная мульти-этапная сборка
- Готов к продакшену

### 2. **Альтернативные Dockerfile:**
- `Dockerfile.bot` - только Telegram бот
- `Dockerfile.web-only` - дубликат корневого для ясности
- `start-services.sh` - скрипт для запуска обоих сервисов

### 3. **Конфигурации платформ:**
- `railway.toml` - конфигурация для Railway
- `render.yaml` - конфигурация для Render

## 🌐 Деплой на различных платформах:

### Railway
```bash
# Автоматически использует корневой Dockerfile
# Настройте переменные окружения в веб-интерфейсе
```

### Render
```bash
# Использует render.yaml для конфигурации
# Добавьте переменные окружения в настройках сервиса
```

### Docker Hub / любая Docker платформа
```bash
# Сборка
docker build -t codev-app .

# Запуск
docker run -p 3000:3000 \
  -e DATABASE_URL="your_db_url" \
  -e BOT_TOKEN="your_bot_token" \
  codev-app
```

### Vercel / Netlify (только веб)
Используйте `Dockerfile.web-only`:
```bash
# Переименуйте для деплоя
mv Dockerfile.web-only Dockerfile
```

## ⚙️ Переменные окружения для деплоя:

### Обязательные:
```env
DATABASE_URL=postgresql://user:pass@host:5432/db
# или
DB=postgresql://user:pass@host:5432/db
```

### Для веб-приложения:
```env
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
PORT=3000
OPENAI_API_KEY=your_openai_key
TELEGRAM_BOT_TOKEN=your_telegram_token
ADMINS_TELEGRAM_ID=your_admin_id
```

### Для бота (опционально):
```env
BOT_TOKEN=your_telegram_bot_token
IMGBB_API_KEY=your_imgbb_key
```

## 📊 Варианты деплоя:

### Вариант 1: Только веб-приложение (рекомендуется)
```bash
# Использует корневой Dockerfile
# Деплоит только Next.js приложение
```

| Сервис | Порт | Описание |
|--------|------|----------|
| Web App | 3000 | Next.js приложение |

### Вариант 2: Только бот
```bash
# Переименуйте Dockerfile.bot в Dockerfile
mv Dockerfile.bot Dockerfile
```

| Сервис | Порт | Описание |
|--------|------|----------|
| Telegram Bot | - | Python бот |

### Вариант 3: Раздельный деплой
- Деплойте веб-приложение и бот как отдельные сервисы
- Используйте соответствующие Dockerfile

## 🔧 Troubleshooting:

### Если бот не запускается:
- Проверьте переменную `BOT_TOKEN`
- Бот автоматически отключается если токен не задан

### Если веб-приложение не запускается:
- Проверьте переменную `DATABASE_URL`
- Убедитесь что порт 3000 доступен

### Логи:
```bash
# Локально
docker logs container_name

# На платформе
# Смотрите логи в веб-интерфейсе платформы
```

## 🎯 Быстрый деплой:

1. **Push в репозиторий**
2. **Подключите репозиторий к платформе деплоя**
3. **Настройте переменные окружения**
4. **Запустите деплой**

Платформа автоматически найдет корневой `Dockerfile` и соберет приложение! 🚀
