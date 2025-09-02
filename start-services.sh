#!/bin/sh

# Скрипт запуска обоих сервисов в одном контейнере

echo "🚀 Запуск Codev сервисов..."

# Проверяем переменные окружения
if [ -z "$BOT_TOKEN" ]; then
    echo "⚠️ BOT_TOKEN не задан, бот не будет запущен"
    BOT_DISABLED=true
fi

if [ -z "$DATABASE_URL" ] && [ -z "$DB" ]; then
    echo "⚠️ DATABASE_URL/DB не задан"
fi

# Функция для запуска веб-приложения
start_web() {
    echo "🌐 Запуск веб-приложения..."
    cd /app/web
    node server.js &
    WEB_PID=$!
    echo "✅ Веб-приложение запущено (PID: $WEB_PID)"
}

# Функция для запуска бота
start_bot() {
    if [ "$BOT_DISABLED" = "true" ]; then
        echo "⏭️ Пропуск запуска бота (BOT_TOKEN не задан)"
        return
    fi
    
    echo "🤖 Запуск Telegram бота..."
    cd /app/bot
    python3 main.py &
    BOT_PID=$!
    echo "✅ Telegram бот запущен (PID: $BOT_PID)"
}

# Функция обработки сигналов
cleanup() {
    echo "🛑 Получен сигнал остановки..."
    
    if [ ! -z "$WEB_PID" ]; then
        echo "Остановка веб-приложения (PID: $WEB_PID)"
        kill $WEB_PID 2>/dev/null
    fi
    
    if [ ! -z "$BOT_PID" ]; then
        echo "Остановка бота (PID: $BOT_PID)"
        kill $BOT_PID 2>/dev/null
    fi
    
    echo "✅ Все сервисы остановлены"
    exit 0
}

# Устанавливаем обработчики сигналов
trap cleanup SIGTERM SIGINT SIGQUIT

# Запускаем сервисы
start_web
start_bot

echo "🎉 Все сервисы запущены!"
echo "🌐 Веб-приложение: http://localhost:3000"

if [ "$BOT_DISABLED" != "true" ]; then
    echo "🤖 Telegram бот: Активен"
else
    echo "🤖 Telegram бот: Отключен"
fi

# Ожидаем завершения процессов
wait
