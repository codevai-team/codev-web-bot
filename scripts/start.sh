#!/bin/bash

# Скрипт для запуска всего проекта

echo "🚀 Запуск Codev проекта..."

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не найден! Установите Docker и попробуйте снова."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не найден! Установите Docker Compose и попробуйте снова."
    exit 1
fi

# Проверяем файлы окружения
if [ ! -f "codev/.env" ]; then
    echo "⚠️ Файл codev/.env не найден!"
    echo "📋 Скопируйте codev/env.template в codev/.env и настройте переменные."
    echo "   cp codev/env.template codev/.env"
    exit 1
fi

if [ ! -f "codev-bot/.env" ]; then
    echo "⚠️ Файл codev-bot/.env не найден!"
    echo "📋 Скопируйте codev-bot.env.template в codev-bot/.env и настройте переменные."
    echo "   cp codev-bot.env.template codev-bot/.env"
    exit 1
fi

# Запускаем проект
echo "🏗️ Собираем и запускаем контейнеры..."
docker-compose up --build -d

echo "⏳ Ждем запуска сервисов..."
sleep 10

# Проверяем статус
echo "📊 Статус сервисов:"
docker-compose ps

echo ""
echo "✅ Проект запущен!"
echo "🌐 Веб-приложение: http://localhost:3000"
echo "🤖 Telegram бот запущен и готов к работе"
echo ""
echo "📋 Полезные команды:"
echo "   docker-compose logs -f          # Логи всех сервисов"
echo "   docker-compose logs -f codev-web # Логи веб-приложения"
echo "   docker-compose logs -f codev-bot # Логи бота"
echo "   docker-compose down            # Остановить все сервисы"
