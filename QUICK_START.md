# 🚀 Быстрый запуск Codev проекта

## 1. Настройка окружения

### Для веб-приложения:
```bash
copy codev\env.template codev\.env
```
Отредактируйте `codev\.env` с вашими настройками.

### Для бота:
```bash
copy codev-bot.env.template codev-bot\.env
```
Отредактируйте `codev-bot\.env` и добавьте:
- `BOT_TOKEN` - токен вашего Telegram бота
- `DB` - строка подключения к вашей внешней БД
- `IMGBB_API_KEY` - ключ API для загрузки изображений (опционально)

## 2. Запуск проекта

### Продакшен:
```bash
docker-compose up --build -d
```

### Разработка:
```bash
docker-compose -f docker-compose.dev.yml up --build -d
```

### Windows (через batch):
```bash
scripts\start.bat
```

## 3. Проверка статуса

```bash
docker-compose ps
docker-compose logs -f
```

## 4. Доступ к сервисам

- 🌐 **Веб-приложение**: http://localhost:3000
- 🤖 **Telegram бот**: Работает через Telegram API
- 🗄️ **База данных**: Внешний сервер (настраивается в .env)

## 5. Остановка

```bash
docker-compose down
```

---

**Готово!** 🎉 Веб-приложение и бот теперь работают в контейнерах и подключены к внешней БД.
