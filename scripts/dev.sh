#!/bin/bash

# Скрипт для запуска проекта в режиме разработки

echo "🚀 Запуск Codev проекта в режиме разработки..."

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

# Запускаем проект в режиме разработки
echo "🏗️ Собираем и запускаем контейнеры в режиме разработки..."
docker-compose -f docker-compose.dev.yml up --build -d

echo "⏳ Ждем запуска сервисов..."
sleep 10

# Проверяем статус
echo "📊 Статус сервисов:"
docker-compose -f docker-compose.dev.yml ps

echo ""
echo "✅ Проект запущен в режиме разработки!"
echo "🌐 Веб-приложение: http://localhost:3000 (с hot reload)"
echo "🤖 Telegram бот запущен с автоперезапуском"
echo ""
echo "📋 Полезные команды для разработки:"
echo "   docker-compose -f docker-compose.dev.yml logs -f                    # Логи всех сервисов"
echo "   docker-compose -f docker-compose.dev.yml logs -f codev-web-dev      # Логи веб-приложения"
echo "   docker-compose -f docker-compose.dev.yml logs -f codev-bot-dev      # Логи бота"
echo "   docker-compose -f docker-compose.dev.yml restart codev-bot-dev      # Перезапуск бота"
echo "   docker-compose -f docker-compose.dev.yml down                       # Остановить все сервисы"
